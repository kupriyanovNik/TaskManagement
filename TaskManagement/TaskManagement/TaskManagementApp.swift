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
            ZStack {
                Color.black
                    .ignoresSafeArea()
                ContentView()
                    .opacity(shouldShowOnboarding ? 0.5 : 1)
                    .clipShape(RoundedShape(corners: [.bottomRight, .bottomLeft], radius: shouldShowOnboarding ? 30 : 0))
                    .padding(.bottom, shouldShowOnboarding ? 25 : 0)
                    .ignoresSafeArea()
                    .overlay {
                        if shouldShowOnboarding {
                            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
                                .clipShape(RoundedShape(corners: [.bottomRight, .bottomLeft], radius: 30))
                                .padding(.bottom, 30)
                                .ignoresSafeArea(edges: .top)
                        }
                    }
                    .animation(.spring(), value: shouldShowOnboarding)
            }
            .preferredColorScheme(.light)
        }
    }
}
