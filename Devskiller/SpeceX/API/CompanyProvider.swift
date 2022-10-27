import Foundation
import Promises

protocol CompanyProviderProtocol {
    func fetchCompany2() -> Promise<APIModel.Company>
    func fetchLaunches2() -> Promise<APIModel.Launches>
}

final class CompanyProvider: CompanyProviderProtocol {
    private let client: HTTPClient
    
    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }
    
    func fetchCompany2() -> Promise<APIModel.Company> {
        client.request(CompanyRequest())
    }
    
    func fetchLaunches2() -> Promise<APIModel.Launches> {
        client.request(AllLaunchesRequest())
    }
}
