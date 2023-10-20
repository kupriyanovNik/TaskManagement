//
//  ProfileView.swift
//

import SwiftUI

struct ProfileView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Private Properties

    private var strings = Localizable.Profile.self
    private var systemImages = ImageNames.System.self

    private var allTasksCount: Int {
        coreDataViewModel.allTasks.count
    }

    private var allDoneTasksCount: Int {
        coreDataViewModel.allTasks.filter { $0.isCompleted }.count
    }
    
    private var doneTasksPercentage: Double {
        Double(allDoneTasksCount) / Double(allTasksCount)
    }

    private var allTodayTasksCount: Int {
        coreDataViewModel.allTodayTasks.count
    }

    private var allTodayDoneTasksCount: Int {
        coreDataViewModel.allTodayTasks.filter { $0.isCompleted }.count
    }

    private var doneTodayTasksPercentage: Double {
        Double(allTodayDoneTasksCount) / Double(allTodayTasksCount)
    }

    private let screenWidth = UIScreen.main.bounds.width

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                StatisticsGauge(
                    title: strings.doneTasks,
                    fromValue: allDoneTasksCount,
                    toValue: allTasksCount,
                    accentColor: themeManager.selectedTheme.accentColor
                )

                StatisticsGauge(
                    title: strings.todayDoneTasks,
                    fromValue: allTodayDoneTasksCount,
                    toValue: allTodayTasksCount,
                    accentColor: themeManager.selectedTheme.accentColor
                )
            }
        }
        .makeCustomNavBar {
            headerView()
        }
        .onAppear {
            coreDataViewModel.fetchTodayTasks()
        }
    }

    // MARK: - ViewBuilders

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
        .environmentObject(CoreDataViewModel())
        .environmentObject(ThemeManager())
}
