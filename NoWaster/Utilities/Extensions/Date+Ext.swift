import Foundation

extension Date {
    func expire(in date: Date) -> String{
        var expiryMessage = ""
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: start, to: end)
        let day = components.day!
        
        if day > 1 {
            expiryMessage = "expires in \(day) days"
        } else if day == 1 {
            expiryMessage = "expires in \(day) day"
        } else {
            expiryMessage = "expired"
        }
        
        return expiryMessage
        
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
            return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
        }
}
