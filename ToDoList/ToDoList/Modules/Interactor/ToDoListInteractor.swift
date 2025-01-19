//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

protocol ToDoListInteractorInput {
    func fetchTasks()
    func addTask(_ task: TaskEntity)
    func updateTask(_ task: TaskEntity)
    func deleteTask(by id: Int64)
    func searchTasks(by keyword: String)
}

protocol ToDoListInteractorOutput: AnyObject {
    func didFetchTasks(_ tasks: [TaskEntity])
    func didFailFetchingTasks(with error: Error)
}

final class ToDoListInteractor: ToDoListInteractorInput {
    weak var output: ToDoListInteractorOutput?
    private let networkManager = NetworkManager.shared
    
    func fetchTasks() {
        networkManager.fetchTodos { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let tasks):
                DispatchQueue.main.async {
                    self.output?.didFetchTasks(tasks)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.output?.didFailFetchingTasks(with: error)
                }
            }
        }
    }
    
    func addTask(_ task: TaskEntity) {
        
    }
    
    func updateTask(_ task: TaskEntity) {
        
    }
    
    func deleteTask(by id: Int64) {
        
    }
    
    func searchTasks(by keyword: String) {
        
    }
}
