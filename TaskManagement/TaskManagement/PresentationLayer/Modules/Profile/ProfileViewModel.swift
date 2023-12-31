//
//  ProfileViewModel.swift
//

import SwiftUI

class ProfileViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showGreetings: Bool = true
    @Published var showConfetti: Bool = false 

    @AppStorage(
        Constants.UserDefaultsKeys.lastTimeShowConfetti
    ) var lastTimeShowConfetti: Double = 0 {
        willSet {
            objectWillChange.send()
        }
    }
}
