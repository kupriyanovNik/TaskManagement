//
//  Notifications.swift
//

import Foundation
import UserNotificationsUI
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {

    // MARK: - Static Properties

    static let shared = NotificationManager()

    // MARK: - Inits

    override init() {
        super.init()

        checkNotificationStatus()
    }

    // MARK: - Internal Properties

    var isNotificationEnabled: Bool?

    // MARK: - Internal Functions

    func requestAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound, .criticalAlert]) { success, error in
                if let error {
                    print("DEBUG: \(error.localizedDescription)")
                }
            }
        UNUserNotificationCenter.current().delegate = self
    }

    func removeNotification(with id: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id])
    }

    func removeNotifications(with ids: [String]) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ids)
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
                    print("DEBUG: \(error.localizedDescription)")
                }
            }
    }

    @discardableResult
    func cheduleNotification(
        title: String = "Habit Reminder",
        subtitle: String,
        weekDays: [Int],
        reminderDate: Date
    ) -> [String] {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = .default

        var notificationsIDs: [String] = []
        let weekdaySymbols: [String] = Calendar.current.weekdaySymbols

        for weekDayIndex in weekDays {
            let id = UUID().uuidString

            let min = Calendar.current.component(.minute, from: reminderDate)
            let hour = Calendar.current.component(.hour, from: reminderDate)
            let day = weekdaySymbols.firstIndex { currentDay in
                currentDay == weekdaySymbols[weekDayIndex]
            } ?? -1

            if day != -1 {
                var components = DateComponents()
                components.minute = min
                components.hour = hour
                components.weekday = day + 1

                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

                UNUserNotificationCenter.current()
                    .add(request)

                notificationsIDs.append(id)
            }
        }

        return notificationsIDs
    }

    // MARK: - Crutches

    /// For sending notification in foreground app phase
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.sound, .banner])
    }

    // MARK: - Debug

    func removeAllNotifications() {
        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()
    }

    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { status in
            switch status.authorizationStatus {
            case .notDetermined, .denied, .provisional, .ephemeral:
                self.isNotificationEnabled = false
            case .authorized:
                self.isNotificationEnabled = true
            @unknown default:
                print("DEBUG: unowned notification status")
            }
        }
    }
}
