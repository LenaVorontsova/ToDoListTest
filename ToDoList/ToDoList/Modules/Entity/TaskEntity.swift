//
//  TaskEntity.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import Foundation

struct TaskEntity: Decodable {
    let id: Int64?
    var title: String?
    var todo: String?
    var createdDate: Date?
    var completed: Bool?
}

struct TodoResponse: Decodable {
    let todos: [TaskEntity]
}
