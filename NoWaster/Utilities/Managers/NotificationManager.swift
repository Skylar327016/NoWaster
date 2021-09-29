

import SwiftUI

final class NotificationManager {
    
    static let shared = NotificationManager()
    private init(){}
    
    
    func createNotificationRequest(with item: InventoryItem) {
        let content = UNMutableNotificationContent()
        
        content.body = "Oops! \(item.name) is going to expire soon..."
        content.sound = .default
        let now = Date()
        let oneDayBeforeExpiryDate = item.expiry - 60 * 60 * 24
        let timeInterval = oneDayBeforeExpiryDate - now
        
        if timeInterval < 0 {
            return
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: item.id.recordName, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    func updateNotificationRequest(with item: InventoryItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.recordName])
        createNotificationRequest(with: item)
    }
    
    
    func removeNotificationRequest(with identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
