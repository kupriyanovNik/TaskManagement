//
//  ThemeDefinitions.swift
//

import Foundation
import SwiftUI

struct Theme1: ThemeProtocol {
    var accentColor: Color = .black
    var pageTitleColor: Color = .black
    var themeName: String = "Black"
}

struct Theme2: ThemeProtocol {
    var accentColor: Color = .purple
    var pageTitleColor: Color = .black
    var themeName: String = "Purple/Black"
}

struct Theme3: ThemeProtocol {
    var accentColor: Color = .green
    var pageTitleColor: Color = .black
    var themeName: String = "Green/Black"
}

struct Theme4: ThemeProtocol {
    var accentColor: Color = .orange
    var pageTitleColor: Color = .black
    var themeName: String = "Orange/Black"
}
