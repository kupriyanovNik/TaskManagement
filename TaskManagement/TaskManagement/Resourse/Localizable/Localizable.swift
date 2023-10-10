//
//  Localizable.swift
//

import Foundation

enum Localizable {
    enum Adding {
        static let title = localized("Adding.title")
        static let save = localized("Adding.save")
        static let cancel = localized("Adding.cancel")
        static let taskTitle = localized("Adding.taskTitle")
        static let taskDescription = localized("Adding.taskDescription")
        static let taskDate = localized("Adding.taskDate")
    }
    enum Home {
        static let markAsCompleted = localized("Home.markAsCompleted")
        static let markedAsCompleted = localized("Home.markedAsCompleted")
        static let today = localized("Home.today")
        static let edit = localized("Home.edit")
        static let done = localized("Home.done")
        static let noTasks = localized("Home.noTasks")
    }
    enum Profile {
        static let your = localized("Profile.your")
        static let profile = localized("Profile.profile")
    }
    enum Onboarding {
        static let endOnboarding = localized("Onboarding.endOnboarding")
        static let next = localized("Onboarding.next")
        static let myName = localized("Onboarding.myName")
        static let habits = localized("Onboarding.habits")
    }
    enum Greetings {
        static let morning = localized("Greetings.morning")
        static let day = localized("Greetings.day")
        static let evening = localized("Greetings.evening")
        static let night = localized("Greetings.night")
    }
    enum Settings {
        static let title = localized("Settings.title")
        static let application = localized("Settings.application")
        static let selectTheme = localized("Settings.selectTheme")
    }
}
