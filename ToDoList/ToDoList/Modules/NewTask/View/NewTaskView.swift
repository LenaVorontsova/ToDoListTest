//
//  NewTaskView.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

final class NewTaskView: UIView {
    public lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.contentInsetAdjustmentBehavior = .automatic
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.alwaysBounceVertical = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delaysContentTouches = false
        return view
    }()
    public lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    public lazy var titleTextView: UITextView = {
        let view = UITextView()
        view.text = "Заголовок"
        view.textColor = .white
        view.backgroundColor = .clear
        view.font = .boldSystemFont(ofSize: 34)
        view.sizeToFit()
        view.isScrollEnabled = false
        view.textAlignment = .natural
        view.tintColor = .yellow
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .white.withAlphaComponent(0.7)
        view.textAlignment = .left
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public lazy var todoTextView: UITextView = {
        let view = UITextView()
        view.text = "Введите текст..."
        view.textColor = .white
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 16)
        view.sizeToFit()
        view.isScrollEnabled = false
        view.textAlignment = .natural
        view.tintColor = .yellow
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .black
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateLabel.text = dateFormatter.string(from: date)
        
        self.addSubviews()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleTextView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(todoTextView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            titleTextView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor,
                                               constant: 8),
            titleTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            todoTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            todoTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            todoTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            todoTextView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor,
                                                 constant: -20)
        ])
    }
}
