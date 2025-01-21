//
//  NewTaskPresenter.swift
//  ToDoList
//
//  Created by Елена Воронцова on 20.01.2025.
//

import UIKit

protocol NewTaskPresenterOutput {
    func addNewTask(title: String, todo: String)
    func editTask(task: TaskEntity, title: String, todo: String)
}

final class NewTaskPresenter: NewTaskPresenterOutput {
    var mainVC: ToDoListViewInput?
    
    func addNewTask(title: String, todo: String) {
        let newTask = TaskEntity(id: Int64(Date().timeIntervalSince1970),
                                 title: title,
                                 todo: todo,
                                 createdDate: Date(),
                                 completed: false)
        mainVC?.didAddNewTask(task: newTask)
    }
    
    func editTask(task: TaskEntity, title: String, todo: String) {
        var editedTask = task
        editedTask.title = title
        editedTask.todo = todo
        editedTask.createdDate = Date()
        mainVC?.didEditTask(task: editedTask)
    }
}
