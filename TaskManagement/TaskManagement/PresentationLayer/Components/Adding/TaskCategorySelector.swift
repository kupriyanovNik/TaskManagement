//
//  TaskCategorySelector.swift
//

import SwiftUI

struct TaskCategorySelector: View {

    // MARK: - Property Wrappers

    @Binding var taskCategory: TaskCategory

    // MARK: - Internal Properties

    var accentColor: Color

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                ForEach(TaskCategory.allCases.indices, id: \.self) { index in
                    let mode = TaskCategory.allCases[index]

                    Button {
                        taskCategory = mode
                    } label: {
                        Text(mode.localized)
                            .font(.caption)
                    }
                    .buttonStyle(CategorySelectorButtonStyle())
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 2)
            .background {
                GeometryReader { proxy in
                    let caseCount = TaskCategory.allCases.count
                    
                    accentColor
                        .opacity(0.1)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: proxy.size.width / CGFloat(caseCount))
                        .offset(x: proxy.size.width / CGFloat(caseCount) * CGFloat(taskCategory.rawValue))
                }
            }
        }
        .animation(.default, value: taskCategory)
    }
}

// MARK: - Preview

#Preview {
    TaskCategorySelector(taskCategory: .constant(.normal), accentColor: .purple)
}
