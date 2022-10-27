import Foundation

protocol CompanyProviderProtocol {
    func fetchCompany(completion: @escaping (Result<APIModel.Company, HTTPClientError>) -> Void)
    func fetchLaunches(completion: @escaping (Result<APIModel.Launches, HTTPClientError>) -> Void)
}

class CompanyProvider: CompanyProviderProtocol {
    private let client: HTTPClientProtocol
    
    init(client: HTTPClientProtocol = HTTPClient.shared) {
        self.client = client
    }
    
    func fetchCompany(completion: @escaping (Result<APIModel.Company, HTTPClientError>) -> Void) {
        client.request(CompanyRequest()) { result in
            switch result {
            case .success(let data):
                do {
                    let company = try JSONDecoder().decode(APIModel.Company.self, from: data)
                    completion(.success(company))
                } catch {
                    completion(.failure(.decodeError(message: error.localizedDescription)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchLaunches(completion: @escaping (Result<APIModel.Launches, HTTPClientError>) -> Void) {
        client.request(AllLaunchesRequest()) { result in
            switch result {
            case .success(let data):
                do {
                    let launches = try JSONDecoder().decode(APIModel.Launches.self, from: data)
                    completion(.success(launches))
                } catch {
                    print("error \(error)")
                    completion(.failure(.decodeError(message: error.localizedDescription)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
