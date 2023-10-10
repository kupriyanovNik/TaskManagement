//
//  TaskManagementApp.swift
//

import SwiftUI

@main
struct TaskManagementApp: App {

    // MARK: - Property Wrappers
    @AppStorage(Constants.UserDefaultsKeys.shouldShowOnboarding) var shouldShowOnboarding: Bool = true

    // MARK: - Internal Properties
    var persistenceController = PersistenceController.shared

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            Group {
                if shouldShowOnboarding {
                    OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
                } else {
                    ContentView()
                        .environment(\.managedObjectContext, persistenceController.viewContext)
                }
            }
            .preferredColorScheme(.light)
            .animation(.spring(), value: shouldShowOnboarding)
        }
    }
}
