//
//  NoTasksFound.swift
//

import SwiftUI

struct NotFoundView: View {

    // MARK: - Property Wrappers

    @State private var shouldShowDetail: Bool = false

    // MARK: - Internal Properties

    var title: String
    var description: String? = nil
    var accentColor: Color

    // MARK: - Body

    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .scaleEffect(shouldShowDetail ? 1.3 : 1)


            if let description, shouldShowDetail {
                Text(description)
                    .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
            }
        }
        .multilineTextAlignment(.center)
        .onTapGesture {
            withAnimation(.smooth) {
                shouldShowDetail.toggle()
            }
        }
        .padding()
        .background {
            accentColor
                .opacity(0.1)
                .cornerRadius(10)
                .scaleEffect(description == nil ? 1.5 : 1)
        }

    }
}

#Preview {
    NotFoundView(
        title: "No Tasks found",
        description: "Here You will see your tasks.\nTap \"+\" to add a new one",
        accentColor: .black
    )
}
