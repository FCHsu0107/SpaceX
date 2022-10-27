import Foundation
import Promises

protocol CompanyProviderProtocol {
    func fetchCompany() -> Promise<APIModel.Company>
    func fetchLaunches() -> Promise<APIModel.Launches>
}

final class CompanyProvider: CompanyProviderProtocol {
    private let client: HTTPClient
    
    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }
    
    func fetchCompany() -> Promise<APIModel.Company> {
        client.request(CompanyRequest())
    }
    
    func fetchLaunches() -> Promise<APIModel.Launches> {
        client.request(AllLaunchesRequest())
    }
}
