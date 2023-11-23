//
//  SettingsView.swift
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss

    // MARK: - Private Properties

    private var strings = Localizable.Settings.self
    private var systemImages = ImageNames.System.self

    private var themeSelectionRow: some View {
        Group {
            Text(strings.selectTheme)
                .font(.title2)
                .padding(.leading)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -10) {
                    ForEach(0..<DataSource.themesCount) { themeIndex in
                        let theme = DataSource.getTheme(themeIndex: themeIndex)

                        ThemePickerCell(
                            accentColor: theme.accentColor,
                            pageTitleColor: theme.pageTitleColor,
                            themeName: theme.themeName
                        ) {
                            withAnimation {
                                themeManager.selectedThemeIndex = themeIndex
                            }
                        }
                        .padding(.leading)
                    }
                }
            }
        }
    }

    private var shouldShowScrollAnimationRow: some View {
        HStack {
            Text(strings.showScrollAnimations)
                .font(.title2)

            Spacer()

            RadioButton(
                isSelected: $settingsViewModel.shouldShowScrollAnimation,
                accentColor: themeManager.selectedTheme.accentColor
            )
            .frame(width: 30, height: 30)
        }
        .padding(.horizontal)
    }

    private var shouldShowTabBarAnimationRow: some View {
        HStack {
            Text(strings.showTabBarAnimations)
                .font(.title2)

            Spacer()

            RadioButton(
                isSelected: $settingsViewModel.shouldShowTabBarAnimation,
                accentColor: themeManager.selectedTheme.accentColor
            )
            .frame(width: 30, height: 30)
        }
        .padding(.horizontal)
    }
    
    /// debug option
    private var showOnboardingRow: some View {
        Button {
            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaultsKeys.shouldShowOnboarding)
        } label: {
            Text("show onboarding")
        }
        .padding(.horizontal)
    }

    private var applicationInformationView: some View {
        Group {
            if settingsViewModel.showInformation {
                VStack {
                    Text("Created by Nikita Kupriyanov with ♡")
                    Text("SwiftUI - less code")
                }
                .font(.caption)
                .foregroundColor(.gray)
                .frame(width: 250, height: 60)
                .background {
                    AnimatedGradient(colors: [.yellow, .orange, .green, .purple])
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .padding(5)
                        }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .scale))
            }
        }
    }

    private var removeAllNotificationsRow: some View {
        Button {
            NotificationManager.shared.removeAllNotifications()
        } label: {
            Text("remove all notifications")
        }
        .padding(.horizontal)
    }

    // MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                themeSelectionRow
                Divider()
                if #available(iOS 17, *) {
                    shouldShowScrollAnimationRow
                }
                shouldShowTabBarAnimationRow
                Divider()
                #if DEBUG
                showOnboardingRow
                removeAllNotificationsRow
                #endif
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .safeAreaInset(edge: .bottom) {
            applicationInformationView
        }
        .makeCustomNavBar {
            headerView()
        }
    }

    // MARK: - ViewBuilders
    
    @ViewBuilder func headerView() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: systemImages.backArrow)
                    .foregroundColor(.black)
                    .font(.title2)
            }

            Text(strings.title)
                .bold()
                .font(.largeTitle)
                .foregroundStyle(themeManager.selectedTheme.pageTitleColor)
                .onTapGesture(count: 5) {
                    withAnimation {
                        settingsViewModel.showInformation = true
                    }
                }

            Spacer()
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
        .environmentObject(SettingsViewModel())
}

