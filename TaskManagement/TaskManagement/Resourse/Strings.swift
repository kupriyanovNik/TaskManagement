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
    }

    enum CoreDataNames {
        static let taskManagement = "TaskManagement"
        static let taskModel = "TaskModel"
    }
}


func localized(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
}
