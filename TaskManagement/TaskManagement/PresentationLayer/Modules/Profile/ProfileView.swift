//
//  ProfileView.swift
//

import SwiftUI
import SPConfetti

struct ProfileView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Private Properties

    private var strings = Localizable.Profile.self
    private var systemImages = ImageNames.System.self

    private var allTodayTasksCount: Int {
        coreDataViewModel.allTodayTasks.count
    }

    private var allTodayDoneTasksCount: Int {
        coreDataViewModel.allTodayTasks.filter { $0.isCompleted }.count
    }

    private var doneTodayTasksPercentage: Double {
        Double(allTodayDoneTasksCount) / Double(allTodayTasksCount)
    }

    private var isAllTodayDone: Bool {
        doneTodayTasksPercentage == 1
    }

    private let screenWidth = UIScreen.main.bounds.width

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                sleepTimeCard()

                if !coreDataViewModel.allTodayTasks.isEmpty {
                    StatisticsGauge(
                        title: strings.todayDoneTasks,
                        fromValue: allTodayDoneTasksCount,
                        toValue: allTodayTasksCount,
                        accentColor: themeManager.selectedTheme.accentColor
                    )
                }
            }
        }
        .makeCustomNavBar {
            headerView()
        }
        .onAppear {
            coreDataViewModel.fetchTodayTasks()
            showConfetti()
        }
        .confetti(
            isPresented: $profileViewModel.showConfetti,
            animation: .fullWidthToDown,
            particles: [.star, .heart],
            duration: 3
        )
    }

    // MARK: - ViewBuilders

    @ViewBuilder func sleepTimeCard() -> some View {
            NavigationLink {
                Text("a")
            } label: {
                HStack {
                    Text("Sleeptime Calculator")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Spacer()

                    Image(systemName: "chevron.right")
                }
                .padding()
                .background {
                    themeManager.selectedTheme.accentColor
                        .opacity(0.2)
                        .cornerRadius(10)
                }
            }
            .buttonStyle(HeaderButtonStyle(pressedScale: 1.03))
            .padding(.horizontal)
            .padding(.bottom, 5)
        }

    @ViewBuilder func headerView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 0) {
                    if profileViewModel.showGreetings {
                        Text("♡")
                            .foregroundColor(.gray)
                            .transition(.move(edge: .leading).combined(with: .opacity))
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
            .buttonStyle(HeaderButtonStyle())

        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
        .onAppear {
            delay(3) {
                withAnimation(.default) {
                    profileViewModel.showGreetings = false
                }
            }
        }
    }

    // MARK: - Private Functions

    private func showConfetti() {
        let calendar = Calendar.current
        let lastDate = Date(timeIntervalSince1970: profileViewModel.lastTimeShowConfetti)
        let isToday = calendar.isDateInToday(lastDate)
        let moreOrEqualWhenFive = allTodayTasksCount >= 5
        
        if isAllTodayDone && !isToday && moreOrEqualWhenFive {
            profileViewModel.showConfetti = true
            profileViewModel.lastTimeShowConfetti = Date().timeIntervalSince1970
        }
    }
}

// MARK: - Preview

#Preview {
    ProfileView()
        .environmentObject(ProfileViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(ThemeManager())
}
