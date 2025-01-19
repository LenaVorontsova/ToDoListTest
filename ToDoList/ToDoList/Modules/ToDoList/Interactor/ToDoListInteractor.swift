//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit
import CoreData

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
    private let coreDataManager = CoreDataManager.shared
    
    func fetchTasks() {
        let savedTasks = coreDataManager.fetchTasks()
        
        // If the app is opened for the first time
        if !savedTasks.isEmpty {
            output?.didFetchTasks(savedTasks)
        } else {
            networkManager.fetchTodos { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let tasks):
                    self.coreDataManager.saveFetchedTasks(tasks)
                    
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
    }
    
    func addTask(_ task: TaskEntity) {
        DispatchQueue.global(qos: .background).async {
            self.coreDataManager.addTask(task)
            DispatchQueue.main.async {
                self.fetchTasks()
            }
        }
    }
    
    func updateTask(_ task: TaskEntity) {
        DispatchQueue.global(qos: .background).async {
            self.coreDataManager.updateTask(task)
            DispatchQueue.main.async {
                self.fetchTasks()
            }
        }
    }
    
    func deleteTask(by id: Int64) {
        DispatchQueue.global(qos: .background).async {
            self.coreDataManager.deleteTask(by: id)
        }
    }
    
    func searchTasks(by keyword: String) {
        
    }
}
