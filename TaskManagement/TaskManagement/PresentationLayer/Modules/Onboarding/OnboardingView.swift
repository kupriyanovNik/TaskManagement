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
    private var strings = Localizable.Onboarding.self

    private var registrationView: some View {
        VStack(spacing: 16) {
            CustomTextField(
                inputText: $settingsViewModel.userName,
                placeHolder: "Как к Вам обращаться?",
                strokeColor: .black
            )
            .continueEditing()
            CustomTextField(
                inputText: $settingsViewModel.userAge,
                placeHolder: "Ваш возраст",
                strokeColor: .black
            )
            .keyboardType(.numberPad)
            .continueEditing()
            Button {
                hideOnboarding()
            } label: {
                Text("Войти")
                    .padding()
                    .foregroundColor(.white)
                    .hCenter()
                    .background(.black)
                    .cornerRadius(10)
            }
            .buttonStyle(.plain)
        }
        .padding()
    }

    // MARK: Inits
    init(shouldShowOnboarding: Binding<Bool>) {
        // MARK: - Because 'OnboardingView' initializer is inaccessible due to 'private' protection level
        self._shouldShowOnboarding = shouldShowOnboarding
    }

    // MARK: Body
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .endEditing()
            Group {
                if onboardingViewModel.showGreetings {
                    VStack(spacing: 30) {
                        Text("My\nHabits")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 30, weight: .semibold))

                        Text("Приложение для контроля и отслеживания выполнения задач")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.horizontal)
                    }
                } else {
                    registrationView
                }
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
        .onAppear {
            showRegistrationView()
        }
    }

    // MARK: Private Functions
    private func hideOnboarding() {
        withAnimation(.linear) {
            self.shouldShowOnboarding.toggle()
        }
    }
    private func showRegistrationView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.default) {
                self.onboardingViewModel.showGreetings = false
            }
        }
    }
}

#Preview {
    OnboardingView(shouldShowOnboarding: .constant(false))
        .environmentObject(SettingsViewModel())
}
