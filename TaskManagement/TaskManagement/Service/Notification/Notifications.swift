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
    }

    // MARK: - Internal Properties

    var isNotificationEnabled: Bool?

    // MARK: - Internal Functions

    func requestAuthorization() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: [.alert, .badge, .sound, .criticalAlert]
            ) { success, error in
                if let error {
                    print("DEBUG: \(error.localizedDescription)")
                }
            }

        UNUserNotificationCenter.current().delegate = self
    }

    func removeNotification(with id: String) {
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: [id])
    }

    func removeNotifications(with ids: [String]) {
        UNUserNotificationCenter
            .current()
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
        if isNotificationEnabled == false {
            requestAuthorization()
        }

        let content = makeContent(title: title, subtitle: subtitle, body: body, isCritical: isCritical)

        var dateComp = makeDateComponents(day: day, hour: hour, minute: minute)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)

        let request = makeRequest(id: id, trigger: trigger, content: content)

        UNUserNotificationCenter
            .current()
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
        let calendar = Calendar.current

        let content = makeContent(title: title, subtitle: subtitle, body: "", isCritical: false)

        var notificationsIDs: [String] = []
        let weekdaySymbols: [String] = calendar.weekdaySymbols

        for weekDayIndex in weekDays {
            let id = UUID().uuidString

            let min = calendar.component(.minute, from: reminderDate)
            let hour = calendar.component(.hour, from: reminderDate)
            let day = weekdaySymbols.firstIndex { currentDay in
                currentDay == weekdaySymbols[weekDayIndex]
            } ?? -1

            if day != -1 {
                let components = makeDateComponents(day: day + 1, hour: hour, minute: min)

                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

                let request = makeRequest(id: id, trigger: trigger, content: content)

                UNUserNotificationCenter
                    .current()
                    .add(request)

                notificationsIDs.append(id)
            }
        }

        return notificationsIDs
    }

    func checkNotificationStatus() {
        UNUserNotificationCenter
            .current()
            .getNotificationSettings { status in
                switch status.authorizationStatus {
                case .denied, .ephemeral:
                    self.isNotificationEnabled = false
                case .authorized, .notDetermined, .provisional:
                    self.isNotificationEnabled = true
                @unknown default:
                    print("DEBUG: unowned notification status")
                }
            }
    }

    // MARK: - Crutches

    /// For sending notification in foreground app phase
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.sound, .banner])
    }

    // MARK: - Debug Functions

    func removeAllNotifications() {
        UNUserNotificationCenter
            .current()
            .removeAllPendingNotificationRequests()
    }

    // MARK: - Private Functions

    private func makeRequest(
        id: String,
        trigger: UNCalendarNotificationTrigger,
        content: UNMutableNotificationContent
    ) -> UNNotificationRequest {
        .init(identifier: id, content: content, trigger: trigger)
    }

    private func makeContent(
        title: String,
        subtitle: String,
        body: String,
        isCritical: Bool
    ) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = isCritical ? .defaultCritical : .default

        return content
    }

    private func makeDateComponents(
        day: Int,
        hour: Int,
        minute: Int
    ) -> DateComponents {
        var dateComp = DateComponents()
        dateComp.hour = hour
        dateComp.minute = minute
        dateComp.day = day

        return dateComp
    }
}
