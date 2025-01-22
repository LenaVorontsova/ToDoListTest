//
//  NewTaskPresenterTest.swift
//  ToDoListTests
//
//  Created by Елена Воронцова on 21.01.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class NewTaskPresenterTest: XCTestCase {
    var presenter: NewTaskPresenter!
    var mockMainVC: MockToDoListView!
    
    override func setUp() {
        super.setUp()
        mockMainVC = MockToDoListView()
        presenter = NewTaskPresenter()
        presenter.mainVC = mockMainVC
    }
    
    override func tearDown() {
        presenter = nil
        mockMainVC = nil
        super.tearDown()
    }

    func testAddNewTask_ShouldAddTask() {
        let title = "Test Task"
        let todo = "Test Todo"
        
        presenter.addNewTask(title: title, todo: todo)
        
        XCTAssertTrue(mockMainVC.didAddNewTaskCalled, "didAddNewTask was not called")
        XCTAssertNotNil(mockMainVC.addedTask, "Added task is nil")
        XCTAssertEqual(mockMainVC.addedTask?.title, title, "Task title does not match")
        XCTAssertEqual(mockMainVC.addedTask?.todo, todo, "Task todo does not match")
        XCTAssertFalse(mockMainVC.addedTask?.completed ?? true, "New task should not be completed")
    }
    
    func testEditTask_ShouldEditTask() {
        let originalTask = TaskEntity(id: 1, title: "Original Task", todo: "Original Todo", createdDate: Date(), completed: false)
        let newTitle = "Updated Task"
        let newTodo = "Updated Todo"
        
        let expectation = XCTestExpectation(description: "Pause before editing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.2)
        
        presenter.editTask(task: originalTask, title: newTitle, todo: newTodo)
        
        XCTAssertTrue(mockMainVC.didEditTaskCalled, "didEditTask was not called")
        XCTAssertNotNil(mockMainVC.editedTask, "Edited task is nil")
        XCTAssertEqual(mockMainVC.editedTask?.id, originalTask.id, "Task ID should not change")
        XCTAssertEqual(mockMainVC.editedTask?.title, newTitle, "Task title does not match")
        XCTAssertEqual(mockMainVC.editedTask?.todo, newTodo, "Task todo does not match")
        XCTAssertNotEqual(mockMainVC.editedTask?.createdDate, originalTask.createdDate, "Task creation date should be updated")
    }
}

final class MockToDoListView: ToDoListViewInput {
    var didAddNewTaskCalled = false
    var addedTask: TaskEntity?

    var didEditTaskCalled = false
    var editedTask: TaskEntity?

    func didAddNewTask(task: TaskEntity) {
        didAddNewTaskCalled = true
        addedTask = task
    }

    func didEditTask(task: TaskEntity) {
        didEditTaskCalled = true
        editedTask = task
    }
    
    func displayTasks(_ tasks: [TaskEntity]) { }
    
    func displayError(_ error: String) { }
    
    func updateTask(_ task: TaskEntity) { }
    
    func reloadData() { }
}
