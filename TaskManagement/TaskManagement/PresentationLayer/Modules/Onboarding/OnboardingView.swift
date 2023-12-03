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

    private var greetingsView: some View {
        VStack(spacing: 30) {
            Text("My\nHabits")
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .semibold))

            Text(strings.application)
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal)
        }
    }

    private var registrationView: some View {
        VStack(spacing: 16) {
            Spacer()

            CustomTextField(
                inputText: $settingsViewModel.userName,
                placeHolder: strings.username,
                strokeColor: .black,
                shouldExpandVertically: false
            )
            .onTapContinueEditing()

            CustomTextField(
                inputText: $settingsViewModel.userAge,
                placeHolder: strings.userage,
                strokeColor: .black,
                shouldExpandVertically: false
            )
            .keyboardType(.numberPad)
            .onTapContinueEditing()

            Spacer()

            Button {
                if settingsViewModel.userName.isEmpty ||
                    settingsViewModel.userAge.isEmpty ||
                    settingsViewModel.userName.count > 15 ||
                    settingsViewModel.userAge.count > 15 {
                    onboardingViewModel.showError = true
                } else {
                    hideOnboarding()
                }
            } label: {
                Text(strings.login)
                    .padding()
                    .foregroundColor(.white)
                    .hCenter()
                    .background(.black)
                    .cornerRadius(10)
            }
            .buttonStyle(HeaderButtonStyle(pressedScale: 1.03))
        }
        .padding()
    }

    // MARK: Body

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .onTapEndEditing()

            Group {
                if onboardingViewModel.showGreetings {
                    greetingsView
                } else {
                    registrationView
                }
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
        .onAppear {
            showRegistrationView()
        }
        .alert(strings.error, isPresented: $onboardingViewModel.showError) {}
    }

    // MARK: Private Functions

    private func hideOnboarding() {
        UIApplication.shared
            .sendAction(
                #selector(UIResponder.resignFirstResponder), 
                to: nil,
                from: nil,
                for: nil
            )

        delay(1) {
            withAnimation(.linear) {
                self.shouldShowOnboarding.toggle()
            }
        }
    }
    
    private func showRegistrationView() {
        delay(4) {
            withAnimation(.default) {
                self.onboardingViewModel.showGreetings = false
            }
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView(shouldShowOnboarding: .constant(false))
        .environmentObject(SettingsViewModel())
}
