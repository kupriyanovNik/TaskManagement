//
//  SettingsViewModel.swift
//

import SwiftUI

class SettingsViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showInformation: Bool = false

    @AppStorage(
        Constants.UserDefaultsKeys.userName
    ) var userName: String = "" {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorage(
        Constants.UserDefaultsKeys.userAge
    ) var userAge: String = "" {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorage(
        Constants.UserDefaultsKeys.shouldShowScrollAnimation
    ) var shouldShowScrollAnimation: Bool = true {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorage(
        Constants.UserDefaultsKeys.shouldShowTabBarAnimation
    ) var shouldShowTabBarAnimation: Bool = true {
        willSet {
            objectWillChange.send()
        }
    }

    // TODO: - Add ability to change app icon
    @AppStorage(
        Constants.UserDefaultsKeys.selectedAppIcon
    ) var selectedAppIcon: String = "App Icon 1" {
        willSet {
            objectWillChange.send()
        }
    }
}
