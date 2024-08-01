//
//  WeeksTabView.swift
//  TaskManagement
//
//  Created by Никита Куприянов on 01.08.2024.
//

import Foundation
import SwiftUI

struct WeeksTabView<Content: View>: View {
    @ObservedObject var infiniteCalendarViewModel: InfiniteCalendarViewModel

    @State private var activeTab: Int = 1
    @State private var direction: TimeDirection = .unknown
    @State private var position: CGSize = .zero

    @GestureState private var dragOffset = CGSize.zero

    var content: (WeekModel) -> Content

    var body: some View {
        TabView(selection: $activeTab) {
            content(infiniteCalendarViewModel.weeks[0])
                .frame(maxWidth: .infinity)
                .tag(0)

            content(infiniteCalendarViewModel.weeks[1])
                .frame(maxWidth: .infinity)
                .tag(1)
                .onDisappear {
                    guard direction != .unknown else { return }

                    infiniteCalendarViewModel.update(to: direction)
                    direction = .unknown
                    activeTab = 1
                }

            content(infiniteCalendarViewModel.weeks[2])
                .frame(maxWidth: .infinity)
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: activeTab) { value in
            if value == 0 {
                direction = .past
            } else if value == 2 {
                direction = .future
            }
        }
    }
}
