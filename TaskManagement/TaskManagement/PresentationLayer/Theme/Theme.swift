//
//  Theme.swift
//

import SwiftUI

protocol Theme {
    var accentColor: Color { get }
    var pageTitleColor: Color { get }
    var themeName: String { get }
}
