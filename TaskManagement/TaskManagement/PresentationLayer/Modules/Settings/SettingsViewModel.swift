//
//  SettingsViewModel.swift
//

import SwiftUI

class SettingsViewModel: ObservableObject {

    @Published var showInformation: Bool = false

    // MARK: - User Defaults Variables
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

    @AppStorage("shouldShowScrollAnimation") var shouldShowScrollAnimation: Bool = true {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorage("shouldShowTabBarAnimation") var shouldShowTabBarAnimation: Bool = true {
        willSet {
            objectWillChange.send()
        }
    }

    // TODO: - Add ability to change app icon
    @AppStorage("selectedAppIcon") var selectedAppIcon: String = "App Icon 1" {
        willSet {
            objectWillChange.send()
        }
    }
}
