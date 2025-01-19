//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

protocol ToDoListViewInput: AnyObject {
    func displayTasks(_ tasks: [TaskEntity])
    func displayError(_ error: String)
    func didAddNewTask(task: TaskEntity)
    func didEditTask(task: TaskEntity)
    func reloadData()
}

final class ToDoListViewController: UIViewController {
    private lazy var mainView = ToDoListView(delegate: self)
    
    var router: ToDoListRouterInput?
    var presenter: ToDoListViewOutput?
    
    private var tasks: [TaskEntity] = []
    private var filteredTasks: [TaskEntity] = []
    
    override func loadView() {
        super.loadView()
        
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        filteredTasks = tasks
        
        setupTableView()
        setupSearchBar()
    }
    
    private func setupTableView() {
        self.mainView.toDoListTableView.dataSource = self
        self.mainView.toDoListTableView.delegate = self
        self.mainView.toDoListTableView.register(ToDoListTableViewCell.self,
                                                 forCellReuseIdentifier: ToDoListTableViewCell.identifier)
    }
    
    private func setupSearchBar() {
        self.mainView.searchBar.delegate = self
    }
    
    func editTask(at indexPath: IndexPath) {
        presenter?.addNewTaskTapped(tasks[indexPath.row])
    }
    
    func shareTask(at indexPath: IndexPath) {
        let textToShare = (tasks[indexPath.row].title ?? "") + "\n" + (tasks[indexPath.row].todo ?? "")
        let activity = UIActivityViewController(activityItems: [textToShare],
                                                applicationActivities: nil)
        present(activity, animated: true)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        presenter?.deleteTaskTapped(id: tasks[indexPath.row].id ?? 0)
    }
    
    private func filterTasks(for searchText: String) {
        if searchText.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { task in
                task.title?.lowercased().contains(searchText.lowercased()) == true ||
                task.todo?.lowercased().contains(searchText.lowercased()) == true
            }
        }
        
        self.mainView.toDoListTableView.reloadData()
    }
}

extension ToDoListViewController: ToDoListViewDelegate {
    func addTaskTapped() {
        presenter?.addNewTaskTapped(nil)
    }
}

extension ToDoListViewController: ToDoListTableViewCellDelegate {
    func didToggleCheckbox(for task: TaskEntity) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].completed?.toggle()
        presenter?.updateTaskTapped(task: tasks[index])
        
        DispatchQueue.main.async {
            self.mainView.toDoListTableView.reloadData()
        }
    }
}

extension ToDoListViewController: ToDoListViewInput {
    func displayTasks(_ tasks: [TaskEntity]) {
        self.tasks = tasks
        DispatchQueue.main.async {
            self.mainView.toDoListTableView.reloadData()
            self.mainView.setTasksCount(tasks.count)
        }
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func didAddNewTask(task: TaskEntity) {
        presenter?.viewDidLoad()
    }
    
    func didEditTask(task: TaskEntity) {
        presenter?.updateTaskTapped(task: task)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.mainView.toDoListTableView.reloadData()
        }
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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let task = tasks[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            let previewViewController = TaskPreviewViewController()
            previewViewController.task = task
            return previewViewController
        }) { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.editTask(at: indexPath)
            }
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.shareTask(at: indexPath)
            }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteTask(at: indexPath)
            }
            
            return UIMenu(children: [editAction, shareAction, deleteAction])
        }
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTasks(for: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterTasks(for: "")
    }
}
