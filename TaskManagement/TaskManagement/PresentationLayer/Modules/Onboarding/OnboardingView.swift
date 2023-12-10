//
//  OnboardingView.swift
//

import SwiftUI

struct OnboardingView: View {

    // MARK: Property Wrappers

    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    @Binding var shouldShowOnboarding: Bool

    @State private var showSView: Bool = false
    @State private var showTView: Bool = false

    // MARK: - Private Properties

    private let strings = Localizable.Onboarding.self

    // MARK: Body

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            Text("My\nHabits")
                .bold()
                .font(.largeTitle)
                .offset(y: -100)

            FirstOnboardingView(showNextView: $showSView)
            SecondOnboardingView(showNextView: $showTView)
                .modifier(ShowOnboardingViewAnimated(shouldShow: showSView))
        }

    }
}

// MARK: - Preview

#Preview {
    OnboardingView(shouldShowOnboarding: .constant(false))
        .environmentObject(SettingsViewModel())
}
