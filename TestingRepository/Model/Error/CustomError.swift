import Foundation

enum CustomError: Error {
    case badRequest
    case dataNotFound
    case unknown
    case sessionNotExtists
    case noNetwork
    case error(String)
    case unauthorized
    case methodNotAllowed
}

extension CustomError: LocalizedError {
    public var customDescription: (String, String) {
        switch self {
        
        case .badRequest:
            return ("ERROR", "BAD REQUEST")
        case .dataNotFound:
            return ("ERROR", "DATA NOT FOUND")
        case .unknown:
            return ("ERROR", "UNKNOWN ERROR")
        case .sessionNotExtists:
            return ("ERROR", "SESSION NOT EXSISTS")
        case .noNetwork:
            return ("ERROR", "NO NETWORK")
        case .error(let error):
            return ("ERROR", error)
        case .unauthorized:
            return ("ERROR", "UNAUTHORIZED")
        case .methodNotAllowed:
            return ("ERROR", "METHOD NOT ALLOWED")
        }
    }
}

extension CustomError {
    var rawValue: Int {
        switch self {
        case .badRequest:
            return 1
        case .dataNotFound:
            return 2
        case .unknown:
            return 3
        case .sessionNotExtists:
            return 4
        case .noNetwork:
            return 5
        case .error(_):
            return 6
        case .unauthorized:
            return 7
        case .methodNotAllowed:
            return 8
        }
    }
}

extension CustomError: Equatable {
    static func == (lhs: CustomError, rhs: CustomError) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
