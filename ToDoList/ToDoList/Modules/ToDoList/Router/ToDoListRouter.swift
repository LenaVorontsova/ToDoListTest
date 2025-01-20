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
        let newTaskVC = NewTaskModuleBuilder.build(mainVC: viewController,
                                                   task: task)
        
        viewController?.navigationController?.pushViewController(newTaskVC, animated: true)
    }
}
