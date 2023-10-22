//
//  OnboardingViewModel.swift
//

import Foundation

class OnboardingViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showGreetings: Bool = true
    @Published var showError: Bool = false 
}
