//
//  AllTasksView.swift
//

import SwiftUI

struct AllTasksView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var allTasksViewModel: AllTasksViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var themeManager: ThemeManager

    // MARK: - Private Properties

    private let systemImages = ImageConstants.System.self
    private let strings = Localizable.AllTasks.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            // MARK: I encountered bugs with redrawing due to the Lazy
            VStack(spacing: 20) {
                if coreDataManager.allTasks.isEmpty {
                    Text(strings.noTasks)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .offset(y: 100)

                } else {
                    if allTasksViewModel.filteringCategory == nil {
                        allTasks()
                    } else {
                        tasksFilteredByCategory()
                    }
                }
            }
            .padding()
            .padding(.top)
            .blur(radius: allTasksViewModel.showFilteringView ? 3 : 0)
        }
        .animation(.default, value: coreDataManager.allTasks)
        .animation(.default, value: coreDataManager.tasksFilteredByCategory)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .makeCustomNavBar {
            headerView()
        }
        .onChange(of: allTasksViewModel.filteringCategory) { _ in
            fetchTasksFilteredByCategory()
            allTasksViewModel.isEditing = false
        }
        .overlay {
            if allTasksViewModel.showFilteringView {
                filteringView()
            }
        }
        .onDisappear {
            coreDataManager.fetchTasksFilteredByDate(
                dateToFilter: homeViewModel.currentDay
            )
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func filteringView() -> some View {
        ZStack {
            Color.black
                .opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        allTasksViewModel.showFilteringView = false
                    }
                }

            VStack {
                ZStack {
                    Color.white
                        .clipShape(
                            RoundedShape(
                                corners: [.bottomLeft, .bottomRight],
                                radius: 30 + (allTasksViewModel.verticalOffset / 15)
                            )
                        )
                        .ignoresSafeArea()

                    FilterSelectorView(
                        selectedCategory: $allTasksViewModel.filteringCategory,
                        title: strings.selectCategory,
                        accentColor: themeManager.selectedTheme.accentColor
                    )
                    .opacity(1.0 - (abs(allTasksViewModel.verticalOffset) / 150.0))
                }
                .frame(maxHeight: 200)

                Spacer()
            }
            .offset(y: allTasksViewModel.verticalOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation {
                            allTasksViewModel.verticalOffset = min(0, value.translation.height)
                        }
                    }
                    .onEnded { value in
                        if value.translation.height < -100 {
                            withAnimation {
                                allTasksViewModel.showFilteringView = false
                                    allTasksViewModel.verticalOffset = 0
                            }
                        } else {
                            withAnimation(.spring) {
                                allTasksViewModel.verticalOffset = 0
                            }
                        }
                    }
            )
        }
    }

    @ViewBuilder func allTasks() -> some View {
        ForEach($coreDataManager.allTasks, id: \.id) { $task in
            TaskCardView(
                homeViewModel: homeViewModel,
                navigationManager: navigationManager,
                coreDataManager: coreDataManager,
                settingsViewModel: settingsViewModel,
                themeManager: themeManager,
                isEditing: $allTasksViewModel.isEditing,
                task: $task
            )
        }
    }

    @ViewBuilder func tasksFilteredByCategory() -> some View {
        if coreDataManager.tasksFilteredByCategory.isEmpty {
            Text(strings.noTasks)
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .offset(y: 100)
        } else {
            ForEach($coreDataManager.tasksFilteredByCategory, id: \.id) { $task in
                TaskCardView(
                    homeViewModel: homeViewModel,
                    navigationManager: navigationManager,
                    coreDataManager: coreDataManager,
                    settingsViewModel: settingsViewModel,
                    themeManager: themeManager,
                    isEditing: $allTasksViewModel.isEditing,
                    task: $task
                ) { _ in 
                    fetchTasksFilteredByCategory()
                }
            }
        }
    }

    @ViewBuilder func headerView() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: systemImages.backArrow)
                    .foregroundColor(.black)
                    .font(.title2)
            }

            VStack(alignment: .leading, spacing: 3) {
                if let filteringCategory = allTasksViewModel.filteringCategory {
                    Text(filteringCategory.localizableRawValue)
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(themeManager.selectedTheme.pageTitleColor)
                        .scaleEffect(allTasksViewModel.showHeaderTap ? 1.1 : 1)
                } else {
                    Text(strings.tasks)
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(themeManager.selectedTheme.pageTitleColor)
                        .scaleEffect(allTasksViewModel.showHeaderTap ? 1.1 : 1)
                }
            }
            .hLeading()
            .onLongPressGesture(minimumDuration: 0.7, maximumDistance: 50) {
                ImpactManager.generateFeedback()
                
                withAnimation {
                    allTasksViewModel.showFilteringView = true
                }
            } onPressingChanged: { isPressed in
                withAnimation {
                    allTasksViewModel.showHeaderTap = isPressed
                }
            }


            if !coreDataManager.allTasks.isEmpty {
                Button(allTasksViewModel.editText) {
                    withAnimation {
                        allTasksViewModel.isEditing.toggle()
                    }
                }
                .buttonStyle(HeaderButtonStyle())
                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
            }
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }

    // MARK: - Private Functions

    private func fetchTasksFilteredByCategory() {
        if let filteringCategory = allTasksViewModel.filteringCategory {
            coreDataManager.fetchTasksFilteredByCategory(taskCategory: filteringCategory)
        }
    }

}

// MARK: - Preview

#Preview {
    AllTasksView(
        allTasksViewModel: .init(),
        homeViewModel: .init(),
        settingsViewModel: .init(),
        navigationManager: .init(),
        coreDataManager: .init(),
        themeManager: .init()
    )
}
