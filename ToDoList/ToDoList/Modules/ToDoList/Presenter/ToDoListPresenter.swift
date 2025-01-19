//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

protocol ToDoListViewOutput {
    func viewDidLoad()
    func addTaskTapped(title: String, description: String?)
    func addNewTaskTapped(_ task: TaskEntity?)
    func updateTaskTapped(task: TaskEntity)
    func deleteTaskTapped(id: Int64)
}

final class ToDoListPresenter: ToDoListViewOutput, ToDoListInteractorOutput {
    weak var view: ToDoListViewInput?
    private let interactor: ToDoListInteractorInput
    private let router: ToDoListRouterInput

    init(interactor: ToDoListInteractorInput, router: ToDoListRouterInput) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        interactor.fetchTasks()
    }

    func addTaskTapped(title: String, description: String?) {
        let task = TaskEntity(id: Int64(Date().timeIntervalSince1970),
                              title: title,
                              todo: description,
                              createdDate: Date(),
                              completed: false)
        interactor.addTask(task)
    }
    
    func addNewTaskTapped(_ task: TaskEntity? = nil) {
        router.navigateToTaskDetails(task: task)
    }

    func updateTaskTapped(task: TaskEntity) {
        interactor.updateTask(task)
    }

    func deleteTaskTapped(id: Int64) {
        interactor.deleteTask(by: id)
    }
    
    func didFetchTasks(_ tasks: [TaskEntity]) {
        view?.displayTasks(tasks)
    }
    
    func didFailFetchingTasks(with error: any Error) {
        view?.displayError(error.localizedDescription)
    }
}

