//
//  InfiniteCalendarTodayButton.swift
//  TaskManagement
//
//  Created by Никита Куприянов on 01.08.2024.
//

import SwiftUI

/// unused now
struct InfiniteCalendarTodayButton: View {

    var date: Date

    var action: () -> Void

    var body: some View {
        let chevronDirection: Bool = date > .now

        Button(action: action) {
            Group {
                if #available(iOS 16, *) {
                    Color.black
                        .clipShape(.rect(bottomTrailingRadius: 20, topTrailingRadius: 20))
                } else {
                    Color.black
                        .cornerRadius(20)
                }
            }
            .frame(width: 80, height: 45)
            .overlay {
                HStack(spacing: 5) {
                    if chevronDirection {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }

                    Text("Today")
                        .font(.body)

                    if !chevronDirection {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }
                }
                .foregroundStyle(.white)
            }
        }
        .buttonStyle(HeaderButtonStyle())
        .transition(.move(edge: .leading))
    }
}
