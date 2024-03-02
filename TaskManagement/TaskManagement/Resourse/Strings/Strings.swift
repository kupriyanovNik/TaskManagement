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
