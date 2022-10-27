import Foundation

extension Date {
    func getDateString() -> String {
        getString("dd MMM yyyy")
    }
    
    func getTimeString() -> String {
        getString("HH:mm")
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
