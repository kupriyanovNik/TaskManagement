//
//  HabitsView.swift
//

import SwiftUI

struct HabitsView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var habitsViewModel: HabitsViewModel

    // MARK: - Body

    var body: some View {
        Text("Hello, World!")
    }
}

// MARK: - Preview

#Preview {
    HabitsView()
        .environmentObject(HabitsViewModel())
}
