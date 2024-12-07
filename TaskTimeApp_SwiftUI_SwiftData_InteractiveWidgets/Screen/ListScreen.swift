//
//  ListScreen.swift
//  TaskTimeApp_SwiftUI_SwiftData_InteractiveWidgets
//
//  Created by Eren Elçi on 23.11.2024.
//

import SwiftUI
import SwiftData

struct ListScreen: View {
    @Query(sort: \TaskTime.task,order: .forward) private var taskTime : [TaskTime]
    @State private var isAddTaskTimePresented : Bool = false
    
    
    var body: some View {
        TaskListView(taskTimes: taskTime).toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isAddTaskTimePresented = true
                } label: {
                    Text("Ekle")
                }
            }
        }.sheet(isPresented: $isAddTaskTimePresented) {
            NavigationStack {
                addTaskScreen()
            }
        }
    }
}

#Preview {
    NavigationStack{
        ListScreen().modelContainer(for: [TaskTime.self])
    }
    
}
