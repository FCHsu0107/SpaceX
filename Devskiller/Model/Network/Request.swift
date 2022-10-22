import Foundation

protocol HTTPClientProtocol {
    typealias Result = Swift.Result<Data, HTTPClientError>
    
    func request(_ hpptRequest: HTTPRequest, completion: @escaping (Result) -> Void)
}

enum HTTPClientError: Error {
    case requestError
    case responseError(message: String)
    case decodeError
    case clientError(Data)
    case serverError(message: String)
    case unexpectedError
    
    var message: String {
        switch self {
        case .decodeError, .requestError:
            return "Something went wrong. Please contact technical support."
            
        case .responseError(let message):
            return message
            
        case .clientError:
            return "Server is currently not available. Please try again later."
            
        case .serverError(let message):
            return message
            
        case .unexpectedError:
            return "An unexpected error has occurred. Please contact Customer Support for assistance"
        }
    }
}

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - HTTPRequest

protocol HTTPRequest {
    var baseUrlKey: String { get }
    var method: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var body: [String: Any]? { get }
    var params: [String: String]? { get }
}
