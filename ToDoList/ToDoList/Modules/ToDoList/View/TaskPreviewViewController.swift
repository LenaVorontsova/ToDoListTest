//
//  TaskPreviewViewController.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

class TaskPreviewViewController: UIViewController {
    
    var task: TaskEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    private func setupUI() {
        guard let task = task else { return }
        
        let titleLabel = UILabel()
        titleLabel.text = task.title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let todoLabel = UILabel()
        todoLabel.text = task.todo
        todoLabel.font = .systemFont(ofSize: 12)
        todoLabel.numberOfLines = 0
        todoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        dateLabel.text = task.todo
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
        dateLabel.numberOfLines = 0
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateLabel.text = dateFormatter.string(from: task.createdDate ?? Date())
        
        view.addSubview(titleLabel)
        view.addSubview(todoLabel)
        view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            todoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            todoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            todoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: todoLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        let contentHeight = calculateHeightForContent(title: task.title ?? "",
                                                      todo: task.todo ?? "",
                                                      date: dateLabel.text ?? "")
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: contentHeight)
    }
    
    private func calculateHeightForContent(title: String, todo: String, date: String) -> CGFloat {
        let contentWidth = UIScreen.main.bounds.width - 40
        
        let titleHeight = title.heightWithConstrainedWidth(contentWidth,
                                                           font: .boldSystemFont(ofSize: 16))
        let todoHeight = description.heightWithConstrainedWidth(contentWidth,
                                                                font: .systemFont(ofSize: 12))
        let dateHeight = description.heightWithConstrainedWidth(contentWidth,
                                                                font: .systemFont(ofSize: 12))
        
        return titleHeight + todoHeight + dateHeight + 20 + 20 + 10 + 20
    }
}
