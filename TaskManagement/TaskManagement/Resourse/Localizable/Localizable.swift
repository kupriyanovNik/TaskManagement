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
        static let shouldRemind = localized("Adding.shouldNotificate")
        static let unfinishedTask = localized("Adding.unfinishedTask")
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
        static let application = localized("Onboarding.application")
        static let username = localized("Onboarding.username")
        static let userage = localized("Onboarding.userage")
        static let login = localized("Onboarding.enter")
        static let error = localized("Onboarding.error")
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
        static let showScrollAnimations = localized("Settings.showScrollAnimations")
    }
    enum AllTasks {
        static let taskLowercased = localized("AllTasks.taskLowercased")
        static let tasksLowercased = localized("AllTasks.tasksLowercased")
        static let your = localized("AllTasks.your")
        static let tasks = localized("AllTasks.tasks")
        static let done = localized("AllTasks.done")
        static let edit = localized("AllTasks.edit")
        static let noTasks = localized("Home.noTasks")
        static let markAsCompleted = localized("Home.markAsCompleted")
        static let markedAsCompleted = localized("Home.markedAsCompleted")
    }
}
