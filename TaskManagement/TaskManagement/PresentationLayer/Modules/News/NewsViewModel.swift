//
//  NewsViewModel.swift
//

import SwiftUI

class NewsViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showHeaderTap: Bool = false

    @Published var leastTime: Int = 30 * 60 / 150

    @AppStorage("lastSeenNews") var lastSeenNews: Double = 0

    // MARK: - Private Properties

    private var timer: Timer?

    // MARK: - Internal Functions

    func startTimer() {
        if leastTime != 0 {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.leastTime -= 1
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }

    func resetLeastTime() {
        leastTime = 30 * 60 / 150
    }

}
