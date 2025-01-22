//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

protocol ToDoListViewDelegate: AnyObject {
    func addTaskTapped()
}

final class ToDoListView: UIView {
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 34)
        view.textColor = .white
        view.textAlignment = .left
        view.text = Localize.ToDoList.tasks.getValue()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = Localize.ToDoList.search.getValue()
        view.backgroundColor = .black
        view.searchBarStyle = .minimal
        view.searchTextField.textColor = .white
        view.tintColor = UIColor(red: 254/255, green: 215/255, blue: 2/255, alpha: 1)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public lazy var toDoListTableView: UITableView = {
        let view = UITableView()
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var addTaskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var taskCountLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 11)
        view.textColor = .white
        view.text = Localize.ToDoList.taskCount.getValue()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var addTaskButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "addTaskIcon"), for: .normal)
        view.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: ToDoListViewDelegate?
    
    init(delegate: ToDoListViewDelegate?) {
        super.init(frame: .zero)
        self.delegate = delegate
        
        self.backgroundColor = .black
        self.addSubviews()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(searchBar)
        self.addSubview(toDoListTableView)
        self.addSubview(addTaskView)
        addTaskView.addSubview(taskCountLabel)
        addTaskView.addSubview(addTaskButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            toDoListTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            toDoListTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toDoListTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            addTaskView.topAnchor.constraint(equalTo: toDoListTableView.bottomAnchor),
            addTaskView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            addTaskView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addTaskView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addTaskView.heightAnchor.constraint(equalToConstant: 83),
            
            taskCountLabel.centerXAnchor.constraint(equalTo: addTaskView.centerXAnchor),
            taskCountLabel.topAnchor.constraint(equalTo: addTaskView.topAnchor, constant: 20),
            
            taskCountLabel.topAnchor.constraint(equalTo: addTaskView.topAnchor, constant: 20),
            addTaskButton.trailingAnchor.constraint(equalTo: addTaskView.trailingAnchor)
        ])
    }
    
    @objc func addTaskTapped() {
        self.delegate?.addTaskTapped()
    }
    
    func setTasksCount(_ count: Int) {
        taskCountLabel.text = "\(count)\(Localize.ToDoList.taskCount.getValue())"
    }
}
