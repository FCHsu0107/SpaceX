import Foundation

struct CompanyRequest: HTTPRequest {
    var baseUrlKey = APIContent.baseUrlKey
    var method = HTTPMethod.get
    var path = "/company"
    var headers: [String: String] = [:]
    var body: [String : Any]?
    var params: [String : String]?
}
