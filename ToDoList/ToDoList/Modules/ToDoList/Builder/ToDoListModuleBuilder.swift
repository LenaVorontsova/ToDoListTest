//
//  ToDoListModuleBuilder.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

final class ToDoListModuleBuilder {
    static func build() -> UIViewController {
        let viewController = ToDoListViewController()
        let interactor = ToDoListInteractor()
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter(interactor: interactor, router: router)
        
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.output = presenter
        router.viewController = viewController

        return viewController
    }
}

