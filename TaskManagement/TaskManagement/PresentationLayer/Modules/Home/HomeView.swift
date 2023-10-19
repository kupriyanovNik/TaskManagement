//
//  HomeView.swift
//

import SwiftUI

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
            VStack(spacing: 15) {
                tasksView()
            }
        }
        .onAppear {
            coreDataViewModel.fetchFilteredTasks(dateToFilter: homeViewModel.currentDay)
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
                withAnimation(.default) {
                    homeViewModel.showGreetings = false
                }
            }
        }
        .animation(.spring(), value: coreDataViewModel.filteredTasks)
        .onChange(of: homeViewModel.currentDay) { newCurrentDate in
            coreDataViewModel.fetchFilteredTasks(dateToFilter: newCurrentDate)
        }
        .onChange(of: coreDataViewModel.filteredTasks) { newFilteredTasks in
            if newFilteredTasks.isEmpty {
                homeViewModel.isEditing = false
            }
        }
        .makeCustomNavBar {
            headerView()
        }
    }
    @ViewBuilder func calendarView() -> some View {
        HStack(spacing: 10) {
            ForEach(homeViewModel.currentWeek, id: \.timeIntervalSince1970) { day in

                let isToday = homeViewModel.isToday(date: day)
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
                    feedback()
                    withAnimation {
                        homeViewModel.currentDay = day
                    }
                }

            }
        }
        .padding(.horizontal)
    }

    // MARK: - ViewBuilders
    @ViewBuilder func tasksView() -> some View {
        LazyVStack(spacing: 20) {
            if coreDataViewModel.filteredTasks.isEmpty {
                Text(strings.noTasks)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .offset(y: 100)
            } else {
                ForEach($coreDataViewModel.filteredTasks, id: \.id) { $task in
                    TaskCardView(
                        homeViewModel: homeViewModel,
                        navigationViewModel: navigationViewModel,
                        coreDataViewModel: coreDataViewModel,
                        settingsViewModel: settingsViewModel,
                        themeManager: themeManager,
                        isEditing: $homeViewModel.isEditing,
                        task: $task
                    )
                }
            }
        }
        .padding()
        .padding(.top)
    }
    @ViewBuilder func titleView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                if homeViewModel.showGreetings {
                    Text("\(Date().greeting()), \(settingsViewModel.userName)")
                        .foregroundColor(.gray)
                        .transition(.move(edge: .trailing).combined(with: .opacity).combined(with: .scale))
                } else {
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                        .foregroundColor(.gray)
                        .transition(.move(edge: .leading).combined(with: .opacity).combined(with: .scale))
                }
                Text(strings.today)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(themeManager.selectedTheme.pageTitleColor)
            }
            .hLeading()
            if !coreDataViewModel.filteredTasks.isEmpty {
                Group {
                    if homeViewModel.isEditing {
                        Button(strings.done) {
                            withAnimation {
                                homeViewModel.isEditing.toggle()
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .scale))
                    } else {
                        Button(strings.edit) {
                            withAnimation {
                                homeViewModel.isEditing.toggle()
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
                    }
                }
                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
            }

        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
        .animation(.linear, value: coreDataViewModel.filteredTasks.isEmpty)
    }
    @ViewBuilder func headerView() -> some View {
        VStack(spacing: 0) {
            titleView()
            if !coreDataViewModel.allTasks.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    calendarView()
                }
                .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(NavigationViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(ThemeManager())
}

