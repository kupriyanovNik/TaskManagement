//
//  HomeView.swift
//

import SwiftUI

struct HomeView: View {

    // MARK: - Property Wrappers
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Namespace var animation

    @Environment(\.managedObjectContext) var context

    // MARK: - Private Properties
    private var strings = Localizable.Home.self
    private var systemImages = ImageNames.System.self
    private var dateFormats = Constants.DateFormats.self
    private var animationNames = Constants.MatchedGeometryNames.self

    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                ScrollView(.horizontal, showsIndicators: false) {
                    calendarView()
                }
                tasksView()
            }
        }
        .onAppear {
            coreDataViewModel.fetchFilteredTasks(dateToFilter: homeViewModel.currentDay)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
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
                ForEach(coreDataViewModel.filteredTasks, id: \.id) { task in
                    taskCardView(task: task, isEditing: homeViewModel.isEditing)
                }
            }
        }
        .padding()
        .padding(.top)
    }

    @ViewBuilder func taskCardView(task: TaskModel, isEditing: Bool) -> some View {
        let isCurrentHour = homeViewModel.isCurrentHour(date: task.taskDate ?? Date())
        HStack(alignment: (isEditing ? .center : .top), spacing: 30) {

            if isEditing {
                VStack(spacing: 10) {
                    if task.isCompleted {
                        Button {
                            coreDataViewModel.undoneTask(task: task, date: task.taskDate ?? .now)
                        } label: {
                            Image(systemName: systemImages.xmarkCircleFill)
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                    if task.taskDate?.compare(.now) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? .now) {
                        Button {
                            homeViewModel.editTask = task
                            navigationViewModel.showAddingView.toggle()
                            try? context.save()
                        } label: {
                            Image(systemName: systemImages.pencilCircleFill)
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                    Button {
                        coreDataViewModel.removeTask(task: task, date: task.taskDate ?? .now)
                    } label: {
                        Image(systemName: systemImages.minusCircleFill)
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
            } else {
                VStack(spacing: 10) {
                    Circle()
                        .fill(isCurrentHour ? (task.isCompleted ? .green : themeManager.selectedTheme.accentColor) : .clear)
                        .frame(width: 15, height: 15)
                        .background {
                            Circle()
                                .stroke(themeManager.selectedTheme.accentColor, lineWidth: 1)
                                .padding(-3)
                        }
                        .scaleEffect(isCurrentHour ? 1 : 0.8)
                    Rectangle()
                        .fill(themeManager.selectedTheme.accentColor)
                        .frame(width: 3)
                }
            }
            taskCard(task: task)

        }
        .hLeading()
        .animation(.spring(), value: task.isCompleted)
    }

    @ViewBuilder func taskCard(task: TaskModel) -> some View {
        let isCurrentHour = homeViewModel.isCurrentHour(date: task.taskDate ?? Date())
        VStack {
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(task.taskTitle ?? "Default Title")
                        .font(.title2)
                        .bold()
                    Text(task.taskDescription ?? "Default Description")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .hLeading()
                Text((task.taskDate ?? Date()).formatted(date: .omitted, time: .shortened))
            }

            if isCurrentHour {
                HStack(spacing: 12) {

                    if !task.isCompleted {
                        Button {
                            coreDataViewModel.doneTask(task: task, date: task.taskDate ?? .now)
                        } label: {
                            Image(systemName: systemImages.checkmark)
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }

                    Text(task.isCompleted ? strings.markedAsCompleted : strings.markAsCompleted)
                        .font(.system(size: task.isCompleted ? 14 : 16))
                        .foregroundColor(task.isCompleted ? .gray : .white)
                        .hLeading()

                }
                .padding(.top)
            }

        }
        .foregroundColor(isCurrentHour ? .white : .black)
        .padding(isCurrentHour ? 16 : 0)
        .padding(.bottom, isCurrentHour ? 0 : 10)
        .hLeading()
        .background {
            Color.black.opacity(isCurrentHour ? 0.85 : 0)
                .cornerRadius(25)
        }
    }

    @ViewBuilder func headerView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(homeViewModel.showGreetings ? Date().greeting() : Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                Text(strings.today)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(themeManager.selectedTheme.pageTitleColor)
            }
            .hLeading()
            if !coreDataViewModel.filteredTasks.isEmpty {
                Button(homeViewModel.isEditing ? strings.done : strings.edit) {
                    withAnimation {
                        homeViewModel.isEditing.toggle()
                    }
                }
                .animation(.none, value: homeViewModel.isEditing)
                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
            }

        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
        .environmentObject(NavigationViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(ThemeManager())
}

