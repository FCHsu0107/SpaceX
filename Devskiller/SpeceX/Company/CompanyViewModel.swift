import Foundation
import UIKit

protocol CompanyViewModelProtocol {
//    func fetchCompany()
}

class CompanyViewModel: CompanyViewModelProtocol, ObservableObject {
    private let provider: CompanyProviderProtocol
    
    init(provider: CompanyProviderProtocol = CompanyProvider()) {
        self.provider = provider
    }
}
