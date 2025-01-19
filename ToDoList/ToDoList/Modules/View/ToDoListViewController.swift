//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

final class ToDoListViewController: UIViewController {
    private lazy var mainView = ToDoListView()
    
    private let tasks: [TaskEntity] = []
    
    override func loadView() {
        super.loadView()
        
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        self.mainView.toDoListTableView.dataSource = self
        self.mainView.toDoListTableView.delegate = self
        self.mainView.toDoListTableView.register(ToDoListTableViewCell.self,
                                                 forCellReuseIdentifier: ToDoListTableViewCell.identifier)
    }
}

extension ToDoListViewController: ToDoListTableViewCellDelegate {
    func didToggleCheckbox(for task: TaskEntity) {
        
    }
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ToDoListTableViewCell.identifier,
            for: indexPath
        ) as? ToDoListTableViewCell else { fatalError("ToDoListTableViewCell not found") }
        
        let task = tasks[indexPath.row]
        cell.delegate = self
        cell.configure(task: task)
        
        return cell
    }
    
    
}
