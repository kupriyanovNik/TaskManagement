//
//  TaskManagementApp.swift
//

import SwiftUI

@main
struct TaskManagementApp: App {

    // MARK: - Property Wrappers
    @AppStorage(Constants.UserDefaultsKeys.shouldShowOnboarding) var shouldShowOnboarding: Bool = true

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            Group {
                if shouldShowOnboarding {
                    OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
                } else {
                    ContentView()
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
