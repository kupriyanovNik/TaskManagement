//
//  InfiniteWeekView.swift
//  TaskManagement
//
//  Created by Никита Куприянов on 01.08.2024.
//

import Foundation
import SwiftUI

struct HabitInfiniteWeekView: View {

    @ObservedObject var infiniteCalendarViewModel: InfiniteCalendarViewModel

    var body: some View {
        WeeksTabView(
            infiniteCalendarViewModel: infiniteCalendarViewModel
        ) { week in
            WeekView(
                infiniteCalendarViewModel: infiniteCalendarViewModel,
                week: week
            )
        }
    }
}
