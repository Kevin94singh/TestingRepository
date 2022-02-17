import Foundation

enum CustomError: Error {
    case noNetwork
    case dataNotFound
    case unknown
    case error(String)
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noNetwork:
            return "No network"
        case .dataNotFound:
            return "Data not found"
        case .error(let error):
            return error
        case .unknown:
            return "Unknown error"
        }
    }
}
