//
//  HabitAddingView.swift
//

import SwiftUI

struct HabitAddingView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var habitAddingViewModel: HabitAddingViewModel

    // MARK: - Body

    var body: some View {
        Text("")
    }
}

#Preview {
    HabitAddingView()
        .environmentObject(HabitAddingViewModel())
}
