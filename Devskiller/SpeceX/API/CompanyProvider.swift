import Foundation
import Promises

protocol CompanyProviderProtocol {
    func fetchCompany(completion: @escaping (Result<APIModel.Company, HTTPClientError>) -> Void)
    func fetchLaunches(completion: @escaping (Result<APIModel.Launches, HTTPClientError>) -> Void)
    func fetchCompany2() -> Promise<APIModel.Company>
    func fetchLaunches2() -> Promise<APIModel.Launches>
}

class CompanyProvider: CompanyProviderProtocol {
    private let client: HTTPClient
    
    init(client: HTTPClient = HTTPClient()) {
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
    
    func fetchCompany2() -> Promise<APIModel.Company> {
        client.request(CompanyRequest())
    }
    
    func fetchLaunches2() -> Promise<APIModel.Launches> {
        client.request(AllLaunchesRequest())
    }
}
