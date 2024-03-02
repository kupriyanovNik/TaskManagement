//
//  SettingsViewModel.swift
//

import SwiftUI

class SettingsViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showExpandedThemePicker: Bool = false 

    @Published var showDebugOptions: Bool = false 

    @AppStorage(
        UserDefaultsConstants.userName.rawValue
    ) var userName: String = ""

    @AppStorage(
        UserDefaultsConstants.userAge.rawValue
    ) var userAge: String = ""

    @AppStorage(
        UserDefaultsConstants.shouldShowScrollAnimation.rawValue
    ) var shouldShowScrollAnimation: Bool = true

    @AppStorage(
        UserDefaultsConstants.shouldShowTabBarAnimation.rawValue
    ) var shouldShowTabBarAnimation: Bool = true

    // TODO: - Add ability to change app icon
    @AppStorage(
        UserDefaultsConstants.selectedAppIcon.rawValue
    ) var selectedAppIcon: String = "App Icon 1"
}
