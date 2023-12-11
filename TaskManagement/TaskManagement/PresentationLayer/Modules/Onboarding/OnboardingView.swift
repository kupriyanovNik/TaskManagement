//
//  OnboardingView.swift
//

import SwiftUI

struct OnboardingView: View {

    // MARK: Property Wrappers

    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    @Binding var shouldShowOnboarding: Bool

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

            FirstOnboardingView(
                showNextView: $onboardingViewModel.showSView
            )

            SecondOnboardingView(
                showNextView: $onboardingViewModel.showTView
            )
            .modifier(
                ShowOnboardingViewAnimated(
                    shouldShow: onboardingViewModel.showSView
                )
            )

            RegistrationView(
                settingsViewModel: settingsViewModel,
                showNextView: $onboardingViewModel.showFView
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
            .modifier(
                ShowOnboardingViewAnimated(
                    shouldShow: onboardingViewModel.showTView
                )
            )
        }
        .alert(strings.error, isPresented: $onboardingViewModel.showError) {}
    }

    // MARK: Private Functions

    private func hideOnboarding() {
        hideKeyboard()

        withAnimation(.linear) {
            self.shouldShowOnboarding = false
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView(shouldShowOnboarding: .constant(false))
        .environmentObject(SettingsViewModel())
}
