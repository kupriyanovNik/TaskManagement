//
//  NewsViewModel.swift
//

import SwiftUI
import Combine

class NewsViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showHeaderTap: Bool = false

    @AppStorage("leastTime") var leastTime: Int = 30 //* 60 // 30 min in seconds

    @AppStorage("lastSeenNews") var lastSeenNews: Double = 0

    @AppStorage("lastOpenNews") var lastOpenNews: Double = 0

    // MARK: - Private Properties

    var timer =  Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: - Internal Functions

    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    func stopTimer() {
        timer.upstream.connect().cancel()
    }

    func timerTick() {
        self.leastTime -= 1
    }

    func resetLeastTime() {
        leastTime = 30 //* 60
    }

}
