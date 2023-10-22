//
//  TabBarViewModel.swift
//

import SwiftUI

class TabBarViewModel: ObservableObject {

    // MARK: - Property Wrappers
    
    @Published var gradientStart: UnitPoint = .init(x: 0, y: 0)
    @Published var gradientEnd: UnitPoint = .init(x: 0, y: 2)
    @Published var gradientLineWidth: Double = 5
    @Published var gradientRotation: Double = 0
}
