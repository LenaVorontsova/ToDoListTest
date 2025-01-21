//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

protocol NewTaskViewInput { }

final class NewTaskViewController: UIViewController {
    private lazy var mainView = NewTaskView()
    
    var presenter: NewTaskPresenterOutput?
    var task: TaskEntity?
    
    override func loadView() {
        super.loadView()
        
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupTextViews()
        setupNotifications()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveTask()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.tintColor = UIColor(red: 254/255,
                                                                green: 215/255,
                                                                blue: 2/255,
                                                                alpha: 1)
    }
    
    private func setupTextViews() {
        self.mainView.titleTextView.delegate = self
        self.mainView.todoTextView.delegate = self
        
        self.mainView.titleTextView.text = task?.title ?? "Заголовок"
        self.mainView.todoTextView.text = task?.todo ?? "Введите текст..."
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardSize = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        self.mainView.scrollView.contentInset = UIEdgeInsets(top: 0,
                                                             left: 0,
                                                             bottom: keyboardSize.height + 10,
                                                             right: 0)
        self.mainView.scrollView.scrollIndicatorInsets = self.mainView.scrollView.contentInset
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        self.mainView.scrollView.contentInset = UIEdgeInsets.zero
        self.mainView.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    private func saveTask() {
        if let task = self.task {
            presenter?.editTask(task: self.task ?? TaskEntity(id: task.id),
                                title: self.mainView.titleTextView.text,
                                todo: self.mainView.todoTextView.text)
        } else {
            presenter?.addNewTask(title: self.mainView.titleTextView.text,
                                  todo: self.mainView.todoTextView.text)
        }
    }
}

extension NewTaskViewController: UITextFieldDelegate, UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.mainView.titleTextView {
            if textView.text == "Заголовок" {
                textView.text = ""
            }
        } else {
            if textView.text == "Введите текст..." {
                textView.text = ""
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == self.mainView.titleTextView {
            let currentText = textView.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
            return newText.count <= 100
        } else {
            let currentText = textView.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
            return newText.count <= 5000
        }
    }
}
