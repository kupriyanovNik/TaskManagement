//
//  Notifications.swift
//

import Foundation
import UserNotificationsUI
import UserNotifications


class NotificationManager {

    static let shared = NotificationManager()

    private init() { }

    func requestAuthorization() {
        // TODO: criticalAlert is unused now. plans to separate tasks into categories. a criticalAlert would be appropriate for the 'Hot' category
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound, .criticalAlert]) { success, error in
                if let error {
                    print("DEBUG: \(error.localizedDescription)")
                }
            }
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
        body: String
    ) {
        requestAuthorization()

        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.defaultCritical

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

}
