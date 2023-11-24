//
//  NewsViewModel.swift
//

import SwiftUI
import Combine

class NewsViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showHeaderTap: Bool = false

    @AppStorage("leastTime") var leastTime: Int = 30 * 60 // 30 min in seconds

    @AppStorage("lastSeenNews") var lastSeenNews: Double = 0

    @AppStorage("lastOpenNews") var lastOpenNews: Double = 0

    // MARK: - Private Properties

    var timer =  Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private let calendar = Calendar.current

    // MARK: - Internal Functions

    func stopTimer() {
        timer.upstream.connect().cancel()
    }

    func timerTick() {
        self.leastTime -= 1
    }

    func resetLeastTime() {
        leastTime = 30 * 60
    }

    func appearAction() {
        let isLastOpenToday = calendar.isDateInToday(Date(timeIntervalSince1970: lastOpenNews))

        if !isLastOpenToday {
            lastOpenNews = Date().timeIntervalSince1970
        }

        startTimer()

        if leastTime == -1 || !isLastOpenToday {
            resetLeastTime()
        }
    }

    // MARK: - Private Functions

    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
}
