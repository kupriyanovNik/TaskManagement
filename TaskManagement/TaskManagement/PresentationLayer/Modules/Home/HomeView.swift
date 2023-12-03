//
//  HomeView.swift
//

import SwiftUI
import StoreKit

struct HomeView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Namespace var animation

    // MARK: - Private Properties

    private var strings = Localizable.Home.self
    private var systemImages = ImageNames.System.self
    private var dateFormats = Constants.DateFormats.self
    private var animationNames = Constants.MatchedGeometryNames.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach($coreDataViewModel.tasksFilteredByDate, id: \.id) { $task in
                    TaskCardView(
                        homeViewModel: homeViewModel,
                        navigationViewModel: navigationViewModel,
                        coreDataViewModel: coreDataViewModel,
                        settingsViewModel: settingsViewModel,
                        themeManager: themeManager,
                        isEditing: $homeViewModel.isEditing,
                        task: $task
                    ) { taskDate in
                        coreDataViewModel.fetchTasksFilteredByDate(
                            dateToFilter: homeViewModel.currentDay
                        )
                        
                        if coreDataViewModel.tasksFilteredByDate.isEmpty {
                            homeViewModel.currentDay = .now
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            delay(3) {
                withAnimation(.default) {
                    homeViewModel.showGreetings = false
                }
            }
        }
        .animation(.spring(), value: coreDataViewModel.tasksFilteredByDate)
        .onChange(of: homeViewModel.currentDay) { newCurrentDate in
            coreDataViewModel.fetchTasksFilteredByDate(dateToFilter: newCurrentDate)
        }
        .onChange(of: coreDataViewModel.tasksFilteredByDate) { newFilteredTasks in
            if newFilteredTasks.isEmpty {
                homeViewModel.isEditing = false
            }
        }
        .onChange(of: coreDataViewModel.allTasks.count) { newValue in
            if newValue % 10 == 0 {
                requestReview()
            }
        }
        .makeCustomNavBar {
            headerView()
        }
        .overlay {
            if coreDataViewModel.tasksFilteredByDate.isEmpty {
                NotFoundView(
                    title: strings.noTasks,
                    description: strings.noTasksDescription,
                    accentColor: themeManager.selectedTheme.accentColor
                )
            }
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func calendarView() -> some View {
        HStack(spacing: 10) {
            ForEach(homeViewModel.currentWeek, id: \.timeIntervalSince1970) { day in
                let isToday = homeViewModel.isSameAsSelectedDay(date: day)
                let dateNumber = homeViewModel.extractDate(date: day, format: dateFormats.forDateNumber)
                let dateLiteral = homeViewModel.extractDate(date: day, format: dateFormats.forDateLiteral)

                VStack(spacing: 10) {
                    Text(dateNumber)
                        .font(.system(size: 15))
                        .fontWeight(.semibold)

                    Text(dateLiteral)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)

                    Circle()
                        .fill(.white)
                        .frame(width: 8, height: 8)
                        .opacity(isToday ? 1 : 0)
                }
                .foregroundColor(isToday ? .white : .gray)
                .frame(width: 45, height: 90)
                .background {
                    ZStack {
                        if isToday {
                            Capsule()
                                .fill(themeManager.selectedTheme.accentColor)
                                .matchedGeometryEffect(id: animationNames.forCalendar, in: animation)
                        }
                    }
                }
                .contentShape(Capsule())
                .onTapGesture {
                    ImpactManager.shared.generateFeedback()

                    withAnimation {
                        homeViewModel.currentDay = day
                    }
                }

            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder func headerView() -> some View {
        let isToday = Calendar.current.isDateInToday(homeViewModel.currentDay)
        let headerText = isToday ? strings.today : homeViewModel.currentDay.formatted(
            date: .abbreviated,
            time: .omitted
        )

        VStack(spacing: 0) {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    if isToday {
                        if homeViewModel.showGreetings {
                            Text("\(Date().greeting()), \(settingsViewModel.userName)")
                                .foregroundColor(.gray)
                                .transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.7)))
                        } else {
                            Text(Date().formatted(date: .abbreviated, time: .omitted))
                                .foregroundColor(.gray)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }

                    HStack {
                        if !homeViewModel.showCalendar || homeViewModel.showHeaderTap,
                           !coreDataViewModel.allTasks.isEmpty {
                            Image(systemName: "chevron.down")
                                .font(.title3)
                                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
                                .opacity(homeViewModel.showHeaderTap ? 0.75 : 1)
                                .scaleEffect(homeViewModel.showHeaderTap ? 0.75 : 1)
                                .onTapGesture {
                                    withAnimation {
                                        homeViewModel.showCalendar = true
                                    }
                                }
                        }

                        Group {
                            if #available(iOS 16, *) {
                                Text(headerText)
                                    .bold()
                                    .contentTransition(.numericText())
                            } else {
                                Text(headerText)
                                    .bold()
                            }
                        }
                        .font(isToday ? .largeTitle : .title)
                        .foregroundColor(themeManager.selectedTheme.pageTitleColor)
                        .scaleEffect(homeViewModel.showHeaderTap ? 1.1 : 1)

                    }
                }
                .hLeading()
                .onLongPressGesture(minimumDuration: 0.7, maximumDistance: 50) {
                    withAnimation {
                        ImpactManager.shared.generateFeedback()

                        if coreDataViewModel.allTasks.isEmpty {
                            navigationViewModel.showTaskAddingView.toggle()
                        } else {
                            homeViewModel.showCalendar.toggle()
                        }
                    }
                } onPressingChanged: { isPressed in
                    withAnimation {
                        homeViewModel.showHeaderTap = isPressed
                    }
                }

                if !coreDataViewModel.tasksFilteredByDate.isEmpty {
                    Button(homeViewModel.editText) {
                        withAnimation {
                            homeViewModel.isEditing.toggle()
                        }
                    }
                    .buttonStyle(HeaderButtonStyle())
                    .foregroundColor(themeManager.selectedTheme.pageTitleColor)
                }

            }
            .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
            .padding(.horizontal)
            .padding(.bottom, 5)
            .animation(.linear, value: coreDataViewModel.tasksFilteredByDate.isEmpty)

            if !coreDataViewModel.allTasks.isEmpty && homeViewModel.showCalendar {
                ScrollView(.horizontal, showsIndicators: false) {
                    calendarView()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    // MARK: - Private Functions

    private func requestReview() {
        if let scene = UIApplication.shared
            .connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
        }
    }

}

// MARK: - Preview

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(NavigationViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(ThemeManager())
}

