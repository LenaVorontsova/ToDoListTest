//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

final class ToDoListView: UIView {
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 34)
        view.textColor = .white
        view.textAlignment = .left
        view.text = "Задачи"
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Поиск"
        view.backgroundColor = .black
        
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
    
    init() {
        super.init(frame: .zero)
        
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
            toDoListTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
