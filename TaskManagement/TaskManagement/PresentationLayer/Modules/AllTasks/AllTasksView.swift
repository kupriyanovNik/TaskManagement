//
//  AllTasksView.swift
//

import SwiftUI

struct AllTasksView: View {

    // MARK: - Property Wrappers
    @EnvironmentObject var allTasksViewModel: AllTasksViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Body
    var body: some View {
        ScrollView {
            Text("AllTasks")
        }
        .makeCustomNavBar {
            headerView()
        }
    }
    @ViewBuilder func headerView() -> some View {
        let tasksCount = coreDataViewModel.allTasks.count
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                if allTasksViewModel.showAllTasksCount {
                    let postfix = tasksCount == 1 ? "task" : "tasks"
                    Text("\(tasksCount) \(postfix)")
                        .foregroundColor(.gray)
                        .transition(.move(edge: .trailing).combined(with: .opacity).combined(with: .scale))
                } else {
                    Text("Your")
                        .foregroundColor(.gray)
                        .transition(.move(edge: .leading).combined(with: .opacity).combined(with: .scale))
                }
                Text("Tasks")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(themeManager.selectedTheme.pageTitleColor)
            }
            .hLeading()

        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
        .onAppear {
            withAnimation(.default.delay(3)) {
                allTasksViewModel.showAllTasksCount = false
            }
        }
    }
}

#Preview {
    AllTasksView()
        .environmentObject(CoreDataViewModel())
        .environmentObject(AllTasksViewModel())
        .environmentObject(ThemeManager())
}
