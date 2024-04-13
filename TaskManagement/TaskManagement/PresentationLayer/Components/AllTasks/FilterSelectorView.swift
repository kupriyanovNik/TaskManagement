//
//  FilterSelectorView.swift
//

import SwiftUI

struct FilterSelectorView: View {

    // MARK: - Property Wrappers

    @Binding var selectedCategory: TaskCategory?

    // MARK: - Internal Properties

    var title: String
    var accentColor: Color

    // MARK: - Body
    
    var body: some View {
        VStack {
            Text(title)
                .bold()
                .font(.title)
                .foregroundColor(accentColor)

            HStack {
                ForEach(TaskCategory.allCases, id: \.rawValue) { taskCategory in
                    let isSelected = selectedCategory == taskCategory

                    Text(taskCategory.localized)
                        .font(.title3)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background {
                            accentColor
                                .cornerRadius(10)
                                .opacity(0.1)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            accentColor,
                                            lineWidth: isSelected ? 2 : 0
                                        )
                                }
                        }
                        .onTapGesture {
                            withAnimation {
                                if self.selectedCategory == taskCategory {
                                    self.selectedCategory = nil
                                } else {
                                    self.selectedCategory = taskCategory
                                }
                            }
                        }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    FilterSelectorView(
        selectedCategory: .constant(.normal),
        title: "Selected Filter",
        accentColor: .black
    )
    .padding()
}
