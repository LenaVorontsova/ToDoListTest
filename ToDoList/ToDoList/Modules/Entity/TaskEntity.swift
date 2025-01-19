//
//  TaskEntity.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import Foundation

struct TaskEntity: Decodable {
    let id: Int64?
    let title: String?
    let todo: String?
    let createdDate: Date?
    let completed: Bool?
}

struct TodoResponse: Decodable {
    let todos: [TaskEntity]
}
