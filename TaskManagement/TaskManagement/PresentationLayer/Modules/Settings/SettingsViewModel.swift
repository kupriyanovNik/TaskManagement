//
//  SettingsViewModel.swift
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    // TODO: - Ability to change app icon
    @AppStorage("selectedAppIcon") var selectedAppIcon: String = "App Icon 1" {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorage("userName") var userName: String = "" {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorage("userAge") var userAge: String = "" {
        willSet {
            objectWillChange.send()
        }
    }
}
