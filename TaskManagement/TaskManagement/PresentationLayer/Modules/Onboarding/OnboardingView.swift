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

    private var greetingsView: some View {
        VStack(spacing: 30) {
            Text("My\nHabits")
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .semibold))

            Text("Приложение для контроля и отслеживания выполнения задач")
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal)
        }
    }
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
                if settingsViewModel.userName.isEmpty || settingsViewModel.userAge.isEmpty || settingsViewModel.userName.count > 15 || settingsViewModel.userAge.count > 15 {
                    onboardingViewModel.showError = true
                } else {
                    hideOnboarding()
                }
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
        .alert("Поля не должны быть пустыми и длина каждого их них не должна быть больше 15", isPresented: $onboardingViewModel.showError) {}
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
