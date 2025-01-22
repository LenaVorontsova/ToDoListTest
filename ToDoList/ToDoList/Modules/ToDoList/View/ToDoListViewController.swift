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
    func updateTask(_ task: TaskEntity)
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
        hideKeyboardWhenTappedAround()
    }
    
    private func setupTableView() {
        self.mainView.toDoListTableView.dataSource = self
        self.mainView.toDoListTableView.delegate = self
        self.mainView.toDoListTableView.register(ToDoListTableViewCell.self,
                                                 forCellReuseIdentifier: ToDoListTableViewCell.identifier)
    }
    
    // - MARK: Task Search
    private func setupSearchBar() {
        self.mainView.searchBar.delegate = self
    }
    
    private func filterTasks(for searchText: String) {
        if searchText.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { task in
                task.title?.localizedCaseInsensitiveContains(searchText) == true ||
                task.todo?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        DispatchQueue.main.async {
            self.mainView.toDoListTableView.reloadData()
        }
    }
    
    // - MARK: Context Menu Tasks
    func editTask(at indexPath: IndexPath) {
        presenter?.addNewTaskTapped(filteredTasks[indexPath.row])
    }
    
    func shareTask(at indexPath: IndexPath) {
        let textToShare = (filteredTasks[indexPath.row].title ?? "") + "\n" + (filteredTasks[indexPath.row].todo ?? "")
        let activity = UIActivityViewController(activityItems: [textToShare],
                                                applicationActivities: nil)
        present(activity, animated: true)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        presenter?.deleteTaskTapped(id: filteredTasks[indexPath.row].id ?? 0)
    }
}

// - MARK: ToDoListViewDelegate
extension ToDoListViewController: ToDoListViewDelegate {
    func addTaskTapped() {
        presenter?.addNewTaskTapped(nil)
    }
}

// - MARK: ToDoListTableViewCellDelegate
extension ToDoListViewController: ToDoListTableViewCellDelegate {
    func didToggleCheckbox(for task: TaskEntity) {
        guard let filteredIndex = filteredTasks.firstIndex(where: { $0.id == task.id }) else { return }
        
        filteredTasks[filteredIndex].completed?.toggle()
        
        if let fullIndex = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[fullIndex].completed = filteredTasks[filteredIndex].completed
        }
        
        presenter?.updateTaskTapped(task: filteredTasks[filteredIndex])
        
        let indexPath = IndexPath(row: filteredIndex, section: 0)
        DispatchQueue.main.async {
            self.mainView.toDoListTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

// - MARK: ToDoListViewInput
extension ToDoListViewController: ToDoListViewInput {
    func displayTasks(_ tasks: [TaskEntity]) {
        self.tasks = tasks
        
        if let searchText = self.mainView.searchBar.text, !searchText.isEmpty {
            filterTasks(for: searchText)
        } else {
            filteredTasks = tasks
        }
        
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
        presenter?.addTaskTapped(title: task.title ?? "", todo: task.todo)
    }
    
    func didEditTask(task: TaskEntity) {
        presenter?.updateTaskTapped(task: task)
    }
    
    func updateTask(_ task: TaskEntity) {
        if let fullIndex = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[fullIndex] = task
        }
        
        if let filteredIndex = filteredTasks.firstIndex(where: { $0.id == task.id }) {
            filteredTasks[filteredIndex] = task
            let indexPath = IndexPath(row: filteredIndex, section: 0)
            
            DispatchQueue.main.async {
                self.mainView.toDoListTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.mainView.toDoListTableView.reloadData()
        }
    }
}

// - MARK: UITableViewDelegate, UITableViewDataSource
extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ToDoListTableViewCell.identifier,
            for: indexPath
        ) as? ToDoListTableViewCell else { fatalError("ToDoListTableViewCell not found") }
        
        let task = filteredTasks[indexPath.row]
        cell.delegate = self
        cell.configure(task: task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let task = filteredTasks[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            let previewViewController = TaskPreviewViewController()
            previewViewController.task = task
            return previewViewController
        }) { _ in
            let editAction = UIAction(title: Localize.ToDoList.editTask.getValue(),
                                      image: UIImage(systemName: "pencil")) { _ in
                self.editTask(at: indexPath)
            }
            let shareAction = UIAction(title: Localize.ToDoList.shareTask.getValue(),
                                       image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.shareTask(at: indexPath)
            }
            let deleteAction = UIAction(title: Localize.ToDoList.deleteTask.getValue(),
                                        image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteTask(at: indexPath)
            }
            
            return UIMenu(children: [editAction, shareAction, deleteAction])
        }
    }
}

// - MARK: UISearchBarDelegate
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
