//
//  TaskTimeDetailScreen.swift
//  TaskTimeApp_SwiftUI_SwiftData_InteractiveWidgets
//
//  Created by Eren Elçi on 23.11.2024.
//

import SwiftUI

struct TaskTimeDetailScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var task : String = ""
    @State private var selectedSaat: Int = 0
    @State private var selectedDakika: Int = 0
    @State var completionStatus: Bool = false
    
    let saat = Array(0...23)
    let dakika = Array(0...59)
    
    let taskTime : TaskTime
    
    var body: some View {
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
                Text("Görev Durumu:").font(.headline)
                Picker("Görev Durumu", selection: $completionStatus) {
                                Text("Yapılmadı").tag(false) // `false` -> Yapılmadı
                                Text("Yapıldı").tag(true)   // `true` -> Yapıldı
                            }
                            .pickerStyle(SegmentedPickerStyle()) // Segmented görsel stil
                            .padding()
                Button {
                     taskTime.task = task
                    taskTime.saat = selectedSaat
                    taskTime.dakika = selectedDakika
                    taskTime.isDone = completionStatus
                    do {
                       try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                } label: {
                    Text("Güncelle").font(.title2)
                }

                Spacer()
            }.onAppear {
                task = taskTime.task
                selectedSaat = taskTime.saat
                selectedDakika = taskTime.dakika
                completionStatus = taskTime.isDone
            }
        }
    }
    
    var formattedTime: String {
        String(format: "%02d:%02d", selectedSaat, selectedDakika)
     }
}

#Preview {
    TaskTimeDetailScreen(taskTime: TaskTime(task: "deneme", saat: 12, dakika: 23, isDone: false))
}
