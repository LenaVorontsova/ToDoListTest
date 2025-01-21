//
//  Localize.swift
//  ToDoList
//
//  Created by Елена Воронцова on 21.01.2025.
//

import Foundation

class Localize {
    enum ToDoList: String {
        case tasks
        case search
        case taskCount
        case editTask
        case shareTask
        case deleteTask
        
        func getValue() -> String {
            return ("toDoList." + self.rawValue).getStringByKey()
        }
    }
    
    enum NewTask: String {
        case title
        case todo
        
        func getValue() -> String {
            return ("newTask." + self.rawValue).getStringByKey()
        }
    }
}
