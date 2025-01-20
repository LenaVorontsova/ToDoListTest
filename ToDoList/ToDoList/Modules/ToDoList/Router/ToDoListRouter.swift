//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

protocol ToDoListRouterInput {
    func navigateToTaskDetails(task: TaskEntity?)
}

final class ToDoListRouter: ToDoListRouterInput {
    weak var viewController: ToDoListViewController?
    
    func navigateToTaskDetails(task: TaskEntity?) {
        let newTaskVC = NewTaskViewController()
        let presenter = NewTaskPresenter()
        
        presenter.mainVC = viewController
        newTaskVC.task = task
        newTaskVC.presenter = presenter
        
        viewController?.navigationController?.pushViewController(newTaskVC, animated: true)
    }
}
