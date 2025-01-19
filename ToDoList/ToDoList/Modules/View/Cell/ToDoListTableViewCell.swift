//
//  ToDoListTableViewCell.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

protocol ToDoListTableViewCellDelegate: AnyObject {
    func didToggleCheckbox(for task: TaskEntity)
}

final class ToDoListTableViewCell: UITableViewCell {
    static let identifier = "toDoListTableViewCell"
    
    private lazy var checkButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "checkedIcon"), for: .selected)
        view.setImage(UIImage(named: "uncheckedIcon"), for: .normal)
        view.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .white
        view.textAlignment = .left
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var todoLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .white
        view.textAlignment = .left
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .white
        view.textAlignment = .left
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 6
        view.alignment = .leading
        view.distribution = .fill
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: ToDoListTableViewCellDelegate?
    
    private var task: TaskEntity?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(checkButton)
        contentView.addSubview(stackView)
        contentView.addSubview(separator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            checkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            separator.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configure(task: TaskEntity) {
        self.task = task
        if let completed = task.completed {
            checkButton.isSelected = completed
        }
        if let title = task.title {
            stackView.addArrangedSubview(titleLabel)
            titleLabel.text = title
        }
        if let todo = task.todo {
            stackView.addArrangedSubview(todoLabel)
            todoLabel.text = todo
        }
        if let createdDate = task.createdDate {
            stackView.addArrangedSubview(dateLabel)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let dateString = dateFormatter.string(from: createdDate)
            dateLabel.text = dateString
        }
        updateStyle()
    }
    
    private func updateStyle() {
        if task?.completed == true {
            titleLabel.textColor = .white.withAlphaComponent(0.5)
            todoLabel.textColor = .white.withAlphaComponent(0.5)
            titleLabel.attributedText = NSAttributedString(
                string: titleLabel.text ?? "",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
        } else {
            titleLabel.textColor = .white
            todoLabel.textColor = .white
            titleLabel.attributedText = NSAttributedString(string: titleLabel.text ?? "",
                                                           attributes: nil)
        }
    }
    
    @objc private func checkboxTapped() {
        guard let task = task else { return }
        delegate?.didToggleCheckbox(for: task)
    }
}
