//
//  OnboardingView.swift
//

import SwiftUI

struct OnboardingView: View {

    // MARK: Property Wrappers
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    @State private var isUpscale: Bool = false
    @Binding var shouldShowOnboarding: Bool

    // MARK: - Private Properties
    private var currentText: String {
        OnboardingModel.texts[onboardingViewModel.currentPageIndex]
    }

    private var isLastPage: Bool {
        onboardingViewModel.currentPageIndex == 2
    }

    private var strings = Localizable.Onboarding.self

    private var onboardingBottomBar: some View {
        Group {
            VStack(spacing: 22) {
                Spacer()
                if !isLastPage {
                    OnboardingIndicator(index: $onboardingViewModel.currentPageIndex)
                }
                Button {
                    if isLastPage {
                        hideOnboarding()
                    } else {
                        withAnimation(.linear) {
                            onboardingViewModel.currentPageIndex += 1
                        }
                    }
                } label: {
                    Text(isLastPage ? strings.endOnboarding : strings.next)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 5)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black)
                        }
                }
                .opacity(isUpscale ? 0 : 1)

            }
            .padding(.bottom)
        }
    }

    // MARK: Inits
    init(shouldShowOnboarding: Binding<Bool>) {
        self._shouldShowOnboarding = shouldShowOnboarding
    }

    // MARK: Body
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                if !isUpscale {
                    Text(currentText)
                        .font(.system(size: 40, weight: .semibold))
                }
                HStack(alignment: .center, spacing: 0) {
                    if isLastPage {
                        Text(strings.myName)
                            .font(.system(size: 40, weight: .bold))
                            .offset(y: isLastPage ? 50 : 0)
                            .multilineTextAlignment(.center)
                    }
                    Text(strings.habits)
                        .font(.system(size: 40, weight: .bold))
                        .offset(y: isLastPage ? 50 : 0)
                }
                .scaleEffect(isUpscale ? 1.3 : 1)
                Spacer()
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
        .overlay {
            onboardingBottomBar
        }
    }

    // MARK: Private Functions
    private func hideOnboarding() {
        withAnimation(.linear) {
            self.isUpscale = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.linear) {
                self.shouldShowOnboarding.toggle()
            }
        }
    }
}

#Preview {
    OnboardingView(shouldShowOnboarding: .constant(false))
        .environmentObject(SettingsViewModel())
}
