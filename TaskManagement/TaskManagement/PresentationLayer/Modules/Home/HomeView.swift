//
//  HomeView.swift
//

import SwiftUI
import StoreKit

struct HomeView: View {

    // MARK: - Property Wrappers

    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var infiniteCalendarVM: InfiniteCalendarViewModel

    @Namespace var animation

    // MARK: - Private Properties

    private let strings = Localizable.Home.self
    private let systemImages = ImageConstants.System.self
    private let dateFormats = DateFormatConstants.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach($coreDataManager.tasksFilteredByDate, id: \.id) { $task in
                    TaskCardView(
                        homeViewModel: homeViewModel,
                        navigationManager: navigationManager,
                        coreDataManager: coreDataManager,
                        settingsViewModel: settingsViewModel,
                        themeManager: themeManager,
                        isEditing: $homeViewModel.isEditing,
                        task: $task
                    ) { taskDate in
                        coreDataManager.fetchTasksFilteredByDate(
                            dateToFilter: infiniteCalendarVM.selectedDate
                        )
                        
                        if coreDataManager.tasksFilteredByDate.isEmpty {
                            infiniteCalendarVM.selectedDate = .now
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
        .animation(.spring(), value: coreDataManager.tasksFilteredByDate)
        .onChange(of: infiniteCalendarVM.selectedDate) { newCurrentDate in
            coreDataManager.fetchTasksFilteredByDate(dateToFilter: newCurrentDate)
        }
        .onChange(of: coreDataManager.tasksFilteredByDate) { newFilteredTasks in
            if newFilteredTasks.isEmpty {
                homeViewModel.isEditing = false
            }
        }
        .onChange(of: coreDataManager.allTasks.count) { newValue in
            if newValue % 10 == 0 {
                requestReview()
            }
        }
        .makeCustomNavBar {
            headerView()
        }
        .overlay {
            if coreDataManager.tasksFilteredByDate.isEmpty {
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
        HabitInfiniteWeekView(
            infiniteCalendarViewModel: infiniteCalendarVM
        )
        .frame(height: 92)
    }

    @ViewBuilder func headerView() -> some View {
        let isToday = Calendar.current.isDateInToday(infiniteCalendarVM.selectedDate)
        let headerText = isToday ? strings.today : infiniteCalendarVM.selectedDate.formatted(
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
                           !coreDataManager.allTasks.isEmpty {
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
                        ImpactManager.generateFeedback()

                        if coreDataManager.allTasks.isEmpty {
                            navigationManager.showTaskAddingView.toggle()
                        } else {
                            homeViewModel.showCalendar.toggle()
                        }
                    }
                } onPressingChanged: { isPressed in
                    withAnimation {
                        homeViewModel.showHeaderTap = isPressed
                    }
                }

                if !coreDataManager.tasksFilteredByDate.isEmpty {
                    Button(homeViewModel.editText) {
                        withAnimation {
                            homeViewModel.isEditing.toggle()
                        }
                    }
                    .buttonStyle(HeaderButtonStyle())
                    .foregroundColor(themeManager.selectedTheme.pageTitleColor)
                }

            }
            .foregroundStyle(
                .linearGradient(
                    colors: [.gray, .black],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .padding(.horizontal)
            .padding(.bottom, 5)
            .animation(.linear, value: coreDataManager.tasksFilteredByDate.isEmpty)

            if !coreDataManager.allTasks.isEmpty && homeViewModel.showCalendar {
                calendarView()
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
    HomeView(
        homeViewModel: .init(),
        settingsViewModel: .init(),
        navigationManager: .init(),
        coreDataManager: .init(),
        themeManager: .init(),
        infiniteCalendarVM: .init()
    )
}
