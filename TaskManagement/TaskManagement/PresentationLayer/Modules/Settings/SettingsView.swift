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
                            themeManager.selectedThemeIndex = themeIndex
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
    private var showOnboardingRow: some View {
        Button {
            UserDefaults.standard.setValue(true, forKey: Constants.UserDefaultsKeys.shouldShowOnboarding)
        } label: {
            Text("show onboarding")
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
                #endif
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .makeCustomNavBar {
            headerView()
        }
    }
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
            Spacer()

        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
        .environmentObject(SettingsViewModel())
}

