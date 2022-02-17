import Foundation
import RxSwift
import os.log
import Alamofire

typealias NetworkManagerHelper = NetworkManager

protocol HasNetworkManager {
    var networkManager: NetworkableManager { get }
}

protocol NetworkableManager {
    func makeRequest<T: Codable>(router: URLRequestConvertible) -> Single<T>
    func makeRequest(router: URLRequestConvertible, expectedCodeRange: ClosedRange<Int>) -> Single<Bool>
}

final class NetworkManager {
    public typealias Dependencies = HasNetworkManager
    
    // MARK: - DisposeBag
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let manager: SessionManager = { () -> SessionManager in
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        
        let sessionDelegate = SessionDelegate()
        
        let sessionManager = SessionManager(configuration: configuration, delegate: sessionDelegate, serverTrustPolicyManager: nil)
        
        let authHandler = AuthHandler()
        sessionManager.retrier = authHandler
        sessionManager.adapter = authHandler
        
        return sessionManager
    }()
    
    // MARK: - Dependencies
    
    private let dependencies: Dependencies
    
    // MARK: - Initialization
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension NetworkManager: NetworkableManager {
    func makeRequest<T: Codable>(router: URLRequestConvertible) -> PrimitiveSequence<SingleTrait, T> {
        return Single.create { (single) -> Disposable in
            let request = self.manager.request(router)
                .validate(statusCode: 200...299)
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .failure(let error):
                        single(.failure(self.handle(error: error)))
                    case .success:
                        guard let data = response.data else {
                            single(.failure(CustomError.dataNotFound))
                            return
                        }
                        
                        #if DEVELOPMENT
                        if let responseString = String(data: data, encoding: String.Encoding.utf8) as String? {
                            print(responseString)
                        }
                        #endif
                        
                        do {
                            let mappedObject = try JSONDecoder().decode(T.self, from: data)
                            single(.success(mappedObject))
                        } catch let error {
                            print(error)
                            single(.failure(self.handle(error: error)))
                        }
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func makeRequest(router: URLRequestConvertible, expectedCodeRange: ClosedRange<Int> = 200...201) -> PrimitiveSequence<SingleTrait, Bool> {
        return Single.create { (single) -> Disposable in
            let request = self.manager.request(router).response(completionHandler: { (response) in
                if let error = response.error {
                    single(.failure(self.handle(error: error)))
                    return
                }
                
                guard let statusCode = response.response?.statusCode else {
                    single(.failure(CustomError.unknown))
                    return
                }
                
                switch statusCode {
                case expectedCodeRange:
                    single(.success(true))
                default:
                    single(.failure(CustomError.unknown))
                }
            })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension NetworkManagerHelper {
    private func handle(error: Error) -> CustomError {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            return .noNetwork
        } else {
            return .error(error.localizedDescription)
        }
    }
}
