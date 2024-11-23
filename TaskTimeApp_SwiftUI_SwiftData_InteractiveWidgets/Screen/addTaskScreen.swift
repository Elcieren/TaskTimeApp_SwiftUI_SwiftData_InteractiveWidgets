//
//  ContentView.swift
//  TaskTimeApp_SwiftUI_SwiftData_InteractiveWidgets
//
//  Created by Eren Elçi on 23.11.2024.
//

import SwiftUI
import SwiftData

struct addTaskScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var task : String = ""
    @State private var selectedSaat: Int = 0
    @State private var selectedDakika: Int = 0
    
    let saat = Array(0...23)
    let dakika = Array(0...59)
    
    private var isFormValid : Bool {
        !task.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
        Form {
            TextField(text: $task) {
                Text("Task")
            }
            VStack {
                Text("Seçilen Zaman: \(formattedTime)")
                    .font(.headline)
                    .padding()
                
                HStack {
                    // Saat seçimi
                    Picker("Saat", selection: $selectedSaat) {
                        ForEach(saat, id: \.self) { hour in
                            Text("\(hour) saat").tag(hour)
                        }
                    }
                    .pickerStyle(WheelPickerStyle()) // Tekerlek stili
                    .frame(width: 100, height: 150)
                    .clipped()
                    
                    Text(":")
                        .font(.largeTitle)
                    
                    // Dakika seçimi
                    Picker("Dakika", selection: $selectedDakika) {
                        ForEach(dakika, id: \.self) { minute in
                            Text("\(minute) dakika").tag(minute)
                        }
                    }
                    .pickerStyle(WheelPickerStyle()) // Tekerlek stili
                    .frame(width: 125, height: 150)
                    .clipped()
                }
                .padding()
                
                Spacer()
            }
        }.navigationTitle("TaskTime")
            .toolbar {
                // DismissToolbarbutton
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        //dismiss action
                        dismiss()
                    } label: {
                        Text("Geri Dön")
                    }
                }
                //SaveToolbarbutton
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //Save action
                        let taskTime = TaskTime(task: task, saat: selectedSaat, dakika: selectedDakika, isDone: false)
                        context.insert(taskTime)
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        dismiss()
                        
                    } label: {
                        Text("Kaydet")
                    }.disabled(!isFormValid)
                }
                
            }
        
        
    }
}
    
    
    var formattedTime: String {
        String(format: "%02d:%02d", selectedSaat, selectedDakika)
     }
    
}
   


#Preview {
    addTaskScreen().modelContainer(for: [TaskTime.self])
}
