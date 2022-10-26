import Foundation

struct AllLaunchesRequest: HTTPRequest {
    var baseUrlKey = APIContent.baseUrlKey
    var method = HTTPMethod.get
    var path = "/launches"
    var headers: [String: String] = [:]
    var body: [String : Any]?
    var params: [String : String]?
}
