import UIKit
import Promises

protocol CompanyViewModelProtocol {
//    func fetchCompany()
}

struct CompanyViewState: Equatable {
    let title: String
    let sections: [Section]
    
    struct Section: Equatable, Hashable {
        let title: String
        let Rows: [RowContent]
    }
    
    enum RowContent: Equatable, Hashable {
        case company(Company)
        case launch(Launch)
    }
    
    struct Company: Equatable, Hashable {
        let name: String
        let founder: String
        let estachlishedYear: String
        let numberOfEployee: String
        let lauchSites: String
        let valuation: String
    }
    
    struct Launch: Equatable, Hashable {
        let mission: String
        let dateAndTime: String
        let rocket: String
        let daysKey: String
        let daysValue: String
        let imageUrl: String
        let isSuccessful: Bool
    }
}

class CompanyViewModel: CompanyViewModelProtocol {
    private let provider: CompanyProviderProtocol
    
    init(provider: CompanyProviderProtocol = CompanyProvider()) {
        self.provider = provider
    }
    
    func fetchData() {
        all(provider.fetchCompany2(), provider.fetchLaunches2())
            .then { company, launches in
//                <#code#>
            }
    }
    
}
