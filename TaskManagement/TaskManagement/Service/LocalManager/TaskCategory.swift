//
//  TaskCategory.swift
//

import Foundation

enum TaskCategory {
    case normal, critical
    
    var localizableRawValue: String {
        switch self {
        case .normal:
            "TaskCategory.normal"
        case .critical:
            "TaskCategory.critical"
        }
    }
}
