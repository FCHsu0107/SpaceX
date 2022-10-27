import Foundation

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    func getString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func distance(to date: Date) -> TimeInterval {
        date.timeIntervalSinceReferenceDate - timeIntervalSinceReferenceDate
    }
}
