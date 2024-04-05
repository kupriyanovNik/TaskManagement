//
//  TaskCategory.swift
//

import Foundation

enum TaskCategory: Int, CaseIterable {
    case normal = 0
    case important = 1

    var localized: String {
        switch self {
        case .normal:
            "TaskCategory.normal".localized
        case .important:
            "TaskCategory.important".localized
        }
    }

    static func getLocalized(rawValue: Int16) -> TaskCategory? {
        switch rawValue {
        case 0: .normal
        case 1: .important
        default: nil
        }
    }

    static func getUnwrappedLocalized(rawValue: Int16) -> String {
        getLocalized(rawValue: rawValue)?.localized ?? "Normal"
    }
}
