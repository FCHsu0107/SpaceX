import UIKit
import Promises
import Combine

protocol CompanyViewModelProtocol {
    var data: CompanyViewData { get set }
    func fetchData()
}

struct CompanyViewData: Equatable {
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
        private let name: String
        private let founder: String
        private let foundedYear: String
        private let numberOfEployee: String
        private let launchSites: String
        private let valuation: String
        
        init(_ company: APIModel.Company) {
            name = company.name
            founder = company.founder
            foundedYear = String(company.founded)
            numberOfEployee = String(company.employees)
            launchSites = String(company.launchSites)
            valuation = String(company.valuation)
        }
        
        func description() -> String {
            let format: String = "%@ was founded by %@ in %@. It has now %@ employeess, %@ launch sites, and is valued at USD %@"
            return String(format: format, [name, founder, foundedYear, numberOfEployee, launchSites, valuation])
        }
    }
    
    struct Launch: Equatable, Hashable {
        let mission: String
        let dateAndTime: String
        let rocket: String
        let daysKey: String
        let daysValue: String
        let imageUrl: String?
        let isSuccessful: Bool
        
        init(_ launch: APIModel.Launch) {
            mission = launch.name
            dateAndTime = launch.dateLocal
            rocket = launch.rocket.rawValue
            daysValue = ""
            daysKey = ""
            imageUrl = launch.links.patch.small
            isSuccessful = launch.success ?? false
        }
    }
    
    init(company: APIModel.Company, launches: APIModel.Launches) {
        let companySection = Section(title: "COMPANY", Rows: [.company(Company(company))])
        let launches = launches.map { Launch($0) }
        let launchesSecation = Section(title: "LAUNCHES", Rows: launches.map { .launch($0) })
        self.sections = [companySection, launchesSecation]
    }
    
    init() {
        self.sections = []
    }
}

final class CompanyViewModel: CompanyViewModelProtocol, ObservableObject {
    private let provider: CompanyProviderProtocol
    
    @Published var data = CompanyViewData()
    
    init(provider: CompanyProviderProtocol = CompanyProvider()) {
        self.provider = provider
        fetchData()
    }
    
    func fetchData() {
        all(provider.fetchCompany2(), provider.fetchLaunches2())
            .then { company, launches in
                self.data = CompanyViewData(company: company, launches: launches)
            }
    }
}
