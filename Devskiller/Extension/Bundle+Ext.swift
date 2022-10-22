import Foundation

extension Bundle {
    static func valueForString(_ key: String) -> String? {
        main.infoDictionary?[key] as? String
    }
}
