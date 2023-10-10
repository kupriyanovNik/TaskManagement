//
//  ProfileView.swift
//

import SwiftUI

struct ProfileView: View {

    // MARK: - Property Wrappers
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Private Properties
    private var strings = Localizable.Profile.self
    private var systemImages = ImageNames.System.self

    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text("Profile Page")
        }
        .makeCustomNavBar {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(strings.your)
                        .foregroundColor(.gray)
                    Text(strings.profile)
                        .bold()
                        .font(.largeTitle)
                        .foregroundStyle(themeManager.selectedTheme.pageTitleColor)
                }
                Spacer()
                NavigationLink {
                    SettingsView()
                        .environmentObject(settingsViewModel)
                        .environmentObject(themeManager)
                } label: {
                    Image(systemName: systemImages.gear)
                        .foregroundColor(.black)
                        .font(.title2)
                }

            }
            .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
            .padding(.horizontal)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(SettingsViewModel())
        .environmentObject(ThemeManager())
}
