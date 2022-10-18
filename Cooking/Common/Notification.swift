import UserNotifications
import Foundation

func addNotification(title: String, subtitle: String, timeInterval: TimeInterval, repeats: Bool) {
    ///notify the user of successful save
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}
