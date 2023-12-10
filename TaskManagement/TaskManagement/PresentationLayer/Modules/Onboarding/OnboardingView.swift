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
    @State private var showFView: Bool = false

    // MARK: - Private Properties

    private let strings = Localizable.Onboarding.self

    // MARK: Body

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            Text("My\nHabits")
                .bold()
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .offset(y: -100)

            FirstOnboardingView(showNextView: $showSView)

            SecondOnboardingView(showNextView: $showTView)
                .modifier(ShowOnboardingViewAnimated(shouldShow: showSView))

            RegistrationView(
                settingsViewModel: settingsViewModel,
                showNextView: $showFView
            ) {
                if settingsViewModel.userName.isEmpty ||
                    settingsViewModel.userAge.isEmpty ||
                    settingsViewModel.userName.count > 15 ||
                    settingsViewModel.userAge.count > 15 {
                    onboardingViewModel.showError = true
                } else {
                    hideOnboarding()
                }
            }
            .modifier(ShowOnboardingViewAnimated(shouldShow: showTView))
        }
        .alert(strings.error, isPresented: $onboardingViewModel.showError) {}
    }

    // MARK: Private Functions

    private func hideOnboarding() {
        hideKeyboard()

        delay(1) {
            withAnimation(.linear) {
                self.shouldShowOnboarding = false 
            }
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView(shouldShowOnboarding: .constant(false))
        .environmentObject(SettingsViewModel())
}
