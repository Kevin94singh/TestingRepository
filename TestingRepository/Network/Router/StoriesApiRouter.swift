import Alamofire

enum StoriesApiRouter {
    case getData
}

extension StoriesApiRouter: URLRequestConvertible {
    
    // MARK: - Base URL
    
    var baseUrl: String {
        switch self {
        default: return Configuration.URL.API.base
        }
    }
    
    // MARK: - Headers
    
    var headers: [(value: String, headerField: String)] {
        switch self {
        default: return []
        }
    }
    
    // MARK: - Method
    
    var method: HTTPMethod {
        switch self {
        case .getData:
            return .get
        }
    }
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .getData:
            return "/v1/users/76794126980351029/stories"
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .getData:
            return nil
        }
    }
    
    // MARK: - Parameters
    
    var parameters: [String: Any]? {
        switch self {
        case .getData: return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = URLComponents(string: baseUrl)
        url?.path = path
        if let query = query, !query.isEmpty {
            url?.queryItems = query
        }
        
        var request = URLRequest(url: (url?.url)!) /// safe force unwrap
        request.httpMethod = method.rawValue
        request.timeoutInterval = 15 * 1_000
        request.cachePolicy = .reloadIgnoringCacheData
        
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.headerField)
        }
        
        switch self {
        case .getData:
            return try URLEncoding.default.encode(request, with: parameters ?? [:])
        }
    }
}
