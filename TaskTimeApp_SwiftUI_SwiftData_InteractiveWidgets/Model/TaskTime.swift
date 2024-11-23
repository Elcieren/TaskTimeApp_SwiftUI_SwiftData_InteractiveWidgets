//
//  TaskTime.swift
//  TaskTimeApp_SwiftUI_SwiftData_InteractiveWidgets
//
//  Created by Eren Elçi on 23.11.2024.
//

import Foundation
import SwiftData

@Model
final class TaskTime: Identifiable {
    var id: String = UUID().uuidString
    var task: String
    var saat : Int
    var dakika : Int
    var isDone : Bool = false
    
    init(task: String, saat: Int, dakika: Int, isDone: Bool) {
        self.task = task
        self.saat = saat
        self.dakika = dakika
        self.isDone = isDone
    }
    
    
}
