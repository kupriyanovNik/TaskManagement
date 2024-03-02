//
//  SettingsViewModel.swift
//

import SwiftUI

class SettingsViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showExpandedThemePicker: Bool = false 

    @Published var showDebugOptions: Bool = false 

    @AppStorage(
        UserDefaultsKeys.userName.rawValue
    ) var userName: String = ""

    @AppStorage(
        UserDefaultsKeys.userAge.rawValue
    ) var userAge: String = ""

    @AppStorage(
        UserDefaultsKeys.shouldShowScrollAnimation.rawValue
    ) var shouldShowScrollAnimation: Bool = true

    @AppStorage(
        UserDefaultsKeys.shouldShowTabBarAnimation.rawValue
    ) var shouldShowTabBarAnimation: Bool = true

    // TODO: - Add ability to change app icon
    @AppStorage(
        UserDefaultsKeys.selectedAppIcon.rawValue
    ) var selectedAppIcon: String = "App Icon 1"
}
