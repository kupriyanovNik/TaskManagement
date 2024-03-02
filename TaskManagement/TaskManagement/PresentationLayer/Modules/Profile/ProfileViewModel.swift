//
//  ProfileViewModel.swift
//

import SwiftUI

class ProfileViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showGreetings: Bool = true
    @Published var showConfetti: Bool = false 

    @AppStorage(
        UserDefaultsKeys.lastTimeShowConfetti.rawValue
    ) var lastTimeShowConfetti: Double = 0
}
