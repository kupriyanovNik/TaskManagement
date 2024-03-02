//
//  SettingsView.swift
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var themeManager: ThemeManager

    // MARK: - Private Properties

    private let strings = Localizable.Settings.self
    private let systemImages = ImageConstants.System.self

    private var themeSelectionRow: some View {
        let isExpanded = settingsViewModel.showExpandedThemePicker
        
        return Group {
            HStack {
                Text(strings.selectTheme)

                Image(systemName: systemImages.backArrow)
                    .rotationEffect(.degrees(isExpanded ? 90 : -90))
            }
            .font(.headline)
            .padding(.leading)
            .onTapGesture {
                withAnimation {
                    settingsViewModel.showExpandedThemePicker.toggle()
                }
            }

            if isExpanded {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: -10) {
                        ForEach(0..<ThemeDataSource.themesCount) { themeIndex in
                            let theme = ThemeDataSource.getTheme(themeIndex: themeIndex)
                            let isSelected = theme.accentColor == themeManager.selectedTheme.accentColor

                            ThemePickerCell(
                                theme: theme,
                                isSelected: isSelected
                            ) {
                                withAnimation {
                                    themeManager.selectedThemeIndex = themeIndex
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
    }

    private var shouldShowScrollAnimationRow: some View {
        HStack {
            Text(strings.showScrollAnimations)
                .font(.headline)

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
                .font(.headline)

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
    private var debugOptionsRow: some View {
        let accentColor = themeManager.selectedTheme.accentColor

        return VStack(alignment: .center) {
            Button("show onboarding") {
                UserDefaults.standard
                    .setValue(
                        true,
                        forKey: UserDefaultsConstants.shouldShowOnboarding.rawValue
                    )
            }

            Button("remove all notifications") {
                NotificationManager.shared.removeAllNotifications()
            }
        }
        .font(.headline)
        .foregroundColor(accentColor)
        .padding(.horizontal)
    }

    private var disabledNotificationsRow: some View {
        VStack(alignment: .leading) {
            Text("You disabled notifications")
                .font(.title2)

            Button("Tap to open settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            }

            Divider()
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

                if NotificationManager.shared.isNotificationEnabled == false {
                    disabledNotificationsRow
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .makeCustomNavBar {
            headerView()
        }
        .safeAreaInset(edge: .bottom) {
            bottomDebugMenu()
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
                .onTapGesture {
                    withAnimation {
                        settingsViewModel.showDebugOptions.toggle()
                    }
                }

            Spacer()
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
        .onDisappear {
            settingsViewModel.showDebugOptions = false 
        }
    }

    @ViewBuilder func bottomDebugMenu() -> some View {
        VStack {
            if settingsViewModel.showDebugOptions {
                VStack {
                    debugOptionsRow
                }
                .hCenter()
                .padding(.horizontal, 24)
                .frame(height: 72)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .shadow(color: .white, radius: 100, x: 0, y: 100)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 5)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView(
        settingsViewModel: .init(),
        themeManager: .init()
    )
}

