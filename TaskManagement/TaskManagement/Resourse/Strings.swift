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
    }
    enum CoreDataNames {
        static let taskManagement = "TaskManagement"
        static let taskModel = "TaskModel"
    }
}


func localized(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
}
