//
//  AllTasksView.swift
//

import SwiftUI

struct AllTasksView: View {

    // MARK: - Property Wrappers
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel

    // MARK: - Body
    var body: some View {
        ScrollView {
            Text("AllTasks")
        }
        .makeCustomNavBar {
            Text("A")
        }
    }
}

#Preview {
    AllTasksView()
        .environmentObject(CoreDataViewModel())
}
