import Foundation
import Promises

protocol HTTPClientProtocol {
    typealias Result = Swift.Result<Data, HTTPClientError>
    
    func request(_ hpptRequest: HTTPRequest, completion: @escaping (Result) -> Void)
    func request<T>(_ hpptRequest: HTTPRequest) -> Promise<T> where T: Decodable
}

class HTTPClient: HTTPClientProtocol {
    private let session: Session
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
    func request(_ hpptRequest: HTTPRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        guard let request = makeRequest(hpptRequest) else {
            return completion(Result.failure(HTTPClientError.requestError))
        }
        
        session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                return completion(Result.failure(HTTPClientError.responseError(message: error.localizedDescription)))
            }
            
            guard let data = data else {
                return completion(Result.failure(HTTPClientError.responseError(message: "No data")))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(Result.failure(HTTPClientError.responseError(message: "Can't get HTTPURLResponse")))
            }
            
            let statusCode = response.statusCode
            
            switch statusCode {
            case 200..<300:
                completion(Result.success(data))
            
            case 400..<500:
                completion(Result.failure(HTTPClientError.clientError(data)))
                
            case 500..<600:
                completion(Result.failure(HTTPClientError.serverError(message: "Server status code is between 400 and 500")))
            
            default:
                completion(Result.failure(HTTPClientError.unexpectedError))
            }
            
        }.resume()
    }
    
    func request<T>(_ hpptRequest: HTTPRequest) -> Promise<T> where T : Decodable {
        guard let request = makeRequest(hpptRequest) else {
            return Promise(HTTPClientError.requestError)
        }
        let promise = Promise<T>.pending()
        
        session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                return promise.reject(HTTPClientError.responseError(message: error.localizedDescription))
            }
            
            guard let data = data else {
                return promise.reject(HTTPClientError.responseError(message: "No data"))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return promise.reject(HTTPClientError.responseError(message: "Can't get HTTPURLResponse"))
            }
            
            let statusCode = response.statusCode
            
            switch statusCode {
            case 200..<300:
                do {
                    let item = try JSONDecoder().decode(T.self, from: data)
                    promise.fulfill(item)
                } catch {
                    promise.reject(HTTPClientError.decodeError(message: error.localizedDescription))
                }
            
            case 400..<500:
                promise.reject(HTTPClientError.clientError(data))
                
            case 500..<600:
                promise.reject(HTTPClientError.serverError(message: "Server status code is between 400 and 500"))
            
            default:
                promise.reject(HTTPClientError.unexpectedError)
            }
            
        }.resume()
        return promise
    }
    
    private func makeRequest(_ hpptRequest: HTTPRequest) -> URLRequest? {
        guard let baseUrlString = Bundle.valueForString(hpptRequest.baseUrlKey),
              let path = hpptRequest.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        let urlString = baseUrlString + path
        
        guard var components = URLComponents(string: urlString) else { return nil }
        
        if let params = hpptRequest.params {
            components.queryItems = params.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = hpptRequest.headers
        request.httpMethod = hpptRequest.method.rawValue
        
        if let body = hpptRequest.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        
        return request
    }
}
