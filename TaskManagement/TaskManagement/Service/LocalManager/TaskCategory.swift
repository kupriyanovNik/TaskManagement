//
//  TaskCategory.swift
//

import Foundation

enum TaskCategory: Int, CaseIterable {
    case normal = 0
    case critical = 1

    var localizableRawValue: String {
        switch self {
        case .normal:
            localized("TaskCategory.normal")
        case .critical:
            localized("TaskCategory.critical")
        }
    }
}
