//
//  OnboardingViewModel.swift
//

import Foundation

class OnboardingViewModel: ObservableObject {

    // MARK: - Property Wrappers

    @Published var showError: Bool = false 

    @Published var showSView: Bool = false
    @Published var showTView: Bool = false
    @Published var showFView: Bool = false
}
