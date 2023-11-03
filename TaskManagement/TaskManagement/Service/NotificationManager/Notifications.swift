//
//  Notifications.swift
//

import Foundation
import UserNotificationsUI
import UserNotifications


class NotificationManager: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationManager()

    private override init() { super.init() }

    func requestAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound, .criticalAlert]) { success, error in
                if let error {
                    print("DEBUG: \(error.localizedDescription)")
                }
            }
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - For sending notification in foreground app phase
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.sound, .banner])
    }

    func removeNotification(with id: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id])
    }

    func sendNotification(
        id: String,
        minute: Int,
        hour: Int,
        day: Int,
        title: String,
        subtitle: String,
        body: String,
        isCritical: Bool = false
    ) {
        requestAuthorization()

        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = isCritical ? .defaultCritical : .default

        var dateComp = DateComponents()
        dateComp.hour = hour
        dateComp.minute = minute
        dateComp.day = day

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current()
            .add(request) { error in
                if let error {
                    print(error.localizedDescription)
                }
            }
    }

//    func cheduleNotification(
//        title: String = "Habit Remainder",
//        subtitle: String,
//        weekDays: [String],
//        currentWeekSymbols: [String],
//        remainderDate: Date
//    ) -> [String] {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.subtitle = subtitle
//        content.sound = .default
//
//        var notificationsIDs: [String] = []
//
//        for weekDay in weekDays {
//            let id = UUID().uuidString
//
//            let min = Calendar.current.component(.minute, from: remainderDate)
//            let hour = Calendar.current.component(.hour, from: remainderDate)
//            let day = currentWeekSymbols.firstIndex { currentDay in
//                currentDay == weekDay
//            } ?? -1
//
//            if day != -1 {
//                var components = DateComponents()
//                
//                components.minute = min
//                components.hour = hour
//                components.weekday = day + 1
//
//                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
//
//                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
//
//                UNUserNotificationCenter.current().add(request) { error in
//                    if let error {
//                        print("DEBUG: \(error.localizedDescription)")
//                    }
//                }
//
//                notificationsIDs.append(id)
//            }
//        }
//
//        print("DEBUG: \(notificationsIDs)")
//        return notificationsIDs
//    }

}
