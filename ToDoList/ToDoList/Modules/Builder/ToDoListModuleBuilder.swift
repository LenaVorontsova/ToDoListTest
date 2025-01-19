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
        let presenter = ToDoListPresenter(interactor: interactor)
        
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.output = presenter

        return viewController
    }
}

