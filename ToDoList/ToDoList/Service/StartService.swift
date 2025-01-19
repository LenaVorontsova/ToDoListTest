//
//  StartService.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

final class StartService {
    var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
        configureWindow()
    }
    
    func configureWindow() {
        if let win = window {
            win.rootViewController = ToDoListModuleBuilder.build()
            win.makeKeyAndVisible()
        }
    }
}
