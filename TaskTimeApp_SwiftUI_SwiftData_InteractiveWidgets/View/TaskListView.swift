//
//  TaskListView.swift
//  TaskTimeApp_SwiftUI_SwiftData_InteractiveWidgets
//
//  Created by Eren Elçi on 23.11.2024.
//

import SwiftUI

struct TaskListView: View {
    
    let taskTimes : [TaskTime]
    @Environment(\.modelContext) private var context
    
    
    
    var body: some View {
        List {
            ForEach(taskTimes) { taskTimes in
                NavigationLink(value: taskTimes) {
                    HStack {
                        Text(taskTimes.task).strikethrough(taskTimes.isDone , color: .red).font(.title3)
                        Spacer()
                        Text("\(taskTimes.saat.description):\(taskTimes.dakika.description)")
                    }
                }
            }.onDelete { indexSet in
                indexSet.forEach { index in
                    let selectedTask = taskTimes[index]
                    context.delete(selectedTask)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                 }
            }
        }.navigationDestination(for: TaskTime.self) { taskTime in
            TaskTimeDetailScreen(taskTime: taskTime)
        }
    }
}

/*
 #Preview {
     TaskListView(taskTimes: [TaskTime(task: "Yeme Cik", saat: 14, dakika: 26, isDone: false)]).modelContainer(for: [TaskTime.self])
 }
 */
 
