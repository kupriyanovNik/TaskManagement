//
//  OnboardingIndicator.swift
//

import SwiftUI

/// unused now
struct OnboardingIndicator: View {

    // MARK: - Property Wrapper

    @Binding var index: Int

    // MARK: - Body

    var body: some View {
        HStack {
            ForEach(0..<3) { index in
                if self.index == index {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.black)
                        .frame(width: 30, height: 8)
                    
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(.lightGray))
                        .frame(width: 30, height: 8)
                        .onTapGesture {
                            withAnimation(.linear) {
                                self.index = index
                            }
                        }
                }
            }
        }
    }
}
