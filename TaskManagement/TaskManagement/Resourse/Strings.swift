//
//  Localizable.swift
// 

import Foundation

enum Constants {
    enum DateFormats {
        static let forDateNumber = "dd"
        static let forDateLiteral = "EEE"
    }

    enum MatchedGeometryNames {
        static let forCalendar = "CurrentDay"
    }

    enum UserDefaultsKeys {
        static let shouldShowOnboarding = "shouldShowOnboarding"
        static let selectedTheme = "selectedThemeIndex"
        static let lastTimeShowConfetti = "lastTimeShowConfetti"
        static let userName = "userName"
        static let userAge = "userAge"
        static let shouldShowScrollAnimation = "shouldShowScrollAnimation"
        static let shouldShowTabBarAnimation = "shouldShowTabBarAnimation"
        static let selectedAppIcon = "selectedAppIcon"
        static let leastTime = "leastTime"
        static let lastSeenNews = "lastSeenNews"
        static let lastOpenNews = "lastOpenNews"
    }

    enum CoreDataNames {
        static let taskManagement = "TaskManagement"
        static let taskModel = "TaskModel"
        static let habitModel = "HabitModel"
    }

    enum Network {
        static let urlString = "https://api.spaceflightnewsapi.net"
    }
}


func localized(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
}
