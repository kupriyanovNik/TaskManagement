//
//  OnboardingViewModel.swift
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var showGreetings: Bool = true
    @Published var showError: Bool = false 
}
