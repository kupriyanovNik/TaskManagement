//
//  Internal.swift
//

import SwiftUI
import Foundation

// MARK: - For Async Delay
func delay(
    _ time: Double,
    execute: @escaping () -> ()
) {
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + time, execute: execute)
}

// MARK: - For Hide Keyboard
func hideKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
    )
}
