import Foundation
import Alamofire

final class AuthHandler {
    private let lock = NSRecursiveLock()
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
}

extension AuthHandler: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        let urlRequest = urlRequest
        return urlRequest
    }
}

extension AuthHandler: RequestRetrier {
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                completion(false, 0.0)
            }
        } else {
            completion(false, 0.0)
        }
    }
}
