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
                    ForEach(0..<DataSource.themes.count) { themeIndex in
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
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                themeSelectionRow
                Divider()

            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .makeCustomNavBar {
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
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
        .environmentObject(SettingsViewModel())
}

struct ThemePickerCell: View {
    var accentColor: Color
    var pageTitleColor: Color
    var themeName: String
    var onSelect: () -> ()
    var body: some View {
        VStack {
            Text(themeName)
                .font(.caption)
            HStack(spacing: 0) {
                accentColor
                pageTitleColor
            }
            .frame(width: 100, height: 60)
            .cornerRadius(10)
            .onTapGesture {
                onSelect()
            }
        }
    }
}
