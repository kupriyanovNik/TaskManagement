//
//  ProfileView.swift
//

import SwiftUI

struct ProfileView: View {

    // MARK: - Property Wrappers
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Private Properties
    private var strings = Localizable.Profile.self
    private var systemImages = ImageNames.System.self

    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text("Profile Page")
                .hCenter()
        }
        .makeCustomNavBar {
            headerView()
        }
    }
    @ViewBuilder func headerView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 0) {
                    if profileViewModel.showGreetings {
                        Text("♡")
                            .foregroundColor(.gray)
                            .transition(.move(edge: .leading).combined(with: .opacity).combined(with: .scale))
                    }
                    Text(strings.your)
                        .foregroundColor(.gray)
                }
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
        .onAppear {
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
                withAnimation(.default) {
                    profileViewModel.showGreetings = false
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(ProfileViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(ThemeManager())
}
