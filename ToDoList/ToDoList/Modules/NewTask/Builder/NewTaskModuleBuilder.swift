//
//  NewTaskModuleBuilder.swift
//  ToDoList
//
//  Created by Елена Воронцова on 20.01.2025.
//

import UIKit

final class NewTaskModuleBuilder {
    static func build(mainVC: ToDoListViewController?, task: TaskEntity?) -> UIViewController {
        let viewController = NewTaskViewController()
        let presenter = NewTaskPresenter()
        
        presenter.mainVC = mainVC
        viewController.task = task
        viewController.presenter = presenter

        return viewController
    }
}
