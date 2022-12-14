import UIKit
import Promises

protocol CompanyViewModelProtocol {
    var data: Observable<CompanyViewData> { get set }
    var error: Observable<String> { get set }
    
    func fetchData()
    func filterLaunchYear(_ year: Int, isASE: Bool)
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
        case empty
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
            let format = "%@ was founded by %@ in %@. It has now %@ employeess, %@ launch sites, and is valued at USD %@"
            return String(format: format, name, founder, foundedYear, numberOfEployee, launchSites, valuation)
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
        let date: Date
        
        init(_ launch: APIModel.Launch) {
            date = launch.dateLocal.getDate() ?? Date()
            let distance = Int(Date().distance(to: date))
            let isInThePast = distance < 0
            
            mission = launch.name
            dateAndTime = date.getString("dd MMM yyyy 'at' HH:mm")
            rocket = launch.rocket.rawValue
            daysKey = isInThePast ? "Days since now:" : "Days from now:"
            daysValue = String(distance)
            imageUrl = launch.links.patch.small
            isSuccessful = launch.success ?? true
        }
    }
    
    init(company: APIModel.Company, launches: APIModel.Launches) {
        let companySection = Section(title: "COMPANY", Rows: [.company(Company(company))])
        let launches = launches.map { Launch($0) }
        let launchesSecation = Section(
            title: "LAUNCHES",
            Rows: launches.isEmpty ? [.empty] : launches.map { .launch($0) }
        )
        self.sections = [companySection, launchesSecation]
    }
    
    init(company: Company, launches: [Launch]) {
        let companySection = Section(title: "COMPANY", Rows: [.company(company)])
        let launchesSecation = Section(
            title: "LAUNCHES",
            Rows: launches.isEmpty ? [.empty] : launches.map { .launch($0) }
        )
        self.sections = [companySection, launchesSecation]
    }
    
    init() {
        self.sections = []
    }
}

final class CompanyViewModel: CompanyViewModelProtocol {
    private let provider: CompanyProviderProtocol
    private var company: CompanyViewData.Company?
    private var launches: [CompanyViewData.Launch] = []
    var data: Observable<CompanyViewData> = Observable(CompanyViewData())
    var error: Observable<String> = Observable(nil)
    
    init(provider: CompanyProviderProtocol = CompanyProvider()) {
        self.provider = provider
    }
    
    func fetchData() {
        data.value = nil
        error.value = nil
        all(provider.fetchCompany(), provider.fetchLaunches())
            .then { [weak self] company, launches in
                self?.company = CompanyViewData.Company(company)
                self?.launches = launches.map { CompanyViewData.Launch($0)}
                self?.data.value = CompanyViewData(company: company, launches: launches)
            }.catch { [weak self] _ in
                self?.error.value = "Something went wrong! \nPlaese try it again."
            }
    }
    
    func filterLaunchYear(_ year: Int, isASE: Bool) {
        guard let company = company else { return }
        var launches = launches.filter { $0.date.year == year }
        launches.sort(by: { isASE ? $0.date > $1.date : $0.date < $1.date })
        data.value = CompanyViewData(company: company, launches: launches)
    }
}
