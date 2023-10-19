//
//  TaskCard.swift
//

import SwiftUI

struct TaskCard: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    let task: TaskModel
    var doneImageName: String
    var markAsCompletedName: String
    var markedAsCompletedName: String
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(task.taskCategory ?? "Normal")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text(task.taskTitle ?? "Default Title")
                            .font(.title2)
                            .bold()
                    }
                    Text(task.taskDescription ?? "Default Description")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .hLeading()
                VStack(alignment: .trailing, spacing: 12) {
                    let taskDate = (task.taskDate ?? Date())
                    Text(taskDate.formatted(date: .omitted, time: .shortened))
                    if !Calendar.current.isDateInToday(taskDate) {
                        Text(taskDate.formatted(date: .abbreviated, time: .omitted))
                    }
                }
            }
            HStack(spacing: 12) {
                if !task.isCompleted {
                    Button {
                        coreDataViewModel.doneTask(task: task, date: task.taskDate ?? .now)
                    } label: {
                        Image(systemName: doneImageName)
                            .foregroundStyle(.black)
                            .padding(10)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                Text(task.isCompleted ? markedAsCompletedName : markAsCompletedName)
                    .font(.system(size: 15))
                    .foregroundColor(task.isCompleted ? .gray : .white)
                    .hLeading()
            }
            .padding(.top)
        }
        .foregroundColor(.white)
        .padding(16)
        .hLeading()
        .background {
            Color.black.opacity(0.85)
                .cornerRadius(25)
        }
    }
}
