//
//  ProfileViewModel.swift
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @AppStorage("username") var username: String = "" {
        willSet {
            objectWillChange.send()
        }
    }
}
