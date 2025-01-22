//
//  ToDoListPresenterTest.swift
//  ToDoListTests
//
//  Created by Елена Воронцова on 21.01.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class ToDoListPresenterTest: XCTestCase {
    var presenter: ToDoListPresenter!
    var mockInteractor: MockInteractor!
    var mockRouter: MockRouter!
    var mockView: MockView!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockInteractor()
        mockRouter = MockRouter()
        mockView = MockView()
        presenter = ToDoListPresenter(interactor: mockInteractor, router: mockRouter)
        presenter.view = mockView
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockRouter = nil
        mockView = nil
        super.tearDown()
    }

    // MARK: - ToDoListViewOutput Tests
    func testViewDidLoad_ShouldFetchTasks() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.fetchTasksCalled, "fetchTasks was not called in interactor")
    }

    func testAddTaskTapped_ShouldAddTask() {
        let title = "Test Task"
        let todo = "Test Description"
        
        presenter.addTaskTapped(title: title, todo: todo)
        
        XCTAssertTrue(mockInteractor.addTaskCalled, "addTask was not called in interactor")
        XCTAssertEqual(mockInteractor.taskToAdd?.title, title, "Task title does not match")
        XCTAssertEqual(mockInteractor.taskToAdd?.todo, todo, "Task description does not match")
    }

    func testAddNewTaskTapped_ShouldNavigateToTaskDetails() {
        let task = TaskEntity(id: 1, title: "Task", todo: "Todo", createdDate: Date(), completed: false)
        
        presenter.addNewTaskTapped(task)
        
        XCTAssertTrue(mockRouter.navigateToTaskDetailsCalled, "navigateToTaskDetails was not called in router")
        XCTAssertEqual(mockRouter.taskToNavigate?.id, task.id, "Navigated task ID does not match")
    }

    func testUpdateTaskTapped_ShouldUpdateTask() {
        let task = TaskEntity(id: 1, title: "Task", todo: "Todo", createdDate: Date(), completed: false)
        
        presenter.updateTaskTapped(task: task)
        
        XCTAssertTrue(mockInteractor.updateTaskCalled, "updateTask was not called in interactor")
        XCTAssertEqual(mockInteractor.taskToUpdate?.id, task.id, "Updated task ID does not match")
    }

    func testDeleteTaskTapped_ShouldDeleteTask() {
        let taskId: Int64 = 1
        
        presenter.deleteTaskTapped(id: taskId)
        
        XCTAssertTrue(mockInteractor.deleteTaskCalled, "deleteTask was not called in interactor")
        XCTAssertEqual(mockInteractor.taskIdToDelete, taskId, "Deleted task ID does not match")
    }

    // MARK: - ToDoListInteractorOutput Tests
    func testDidFetchTasks_ShouldDisplayTasks() {
        let tasks = [
            TaskEntity(id: 1, title: "Task 1", todo: "Todo 1", createdDate: Date(), completed: false),
            TaskEntity(id: 2, title: "Task 2", todo: "Todo 2", createdDate: Date(), completed: true)
        ]
        
        presenter.didFetchTasks(tasks)
        
        XCTAssertTrue(mockView.displayTasksCalled, "displayTasks was not called in view")
        XCTAssertEqual(mockView.displayedTasks?.count, tasks.count, "Displayed tasks count does not match")
    }

    func testDidFailFetchingTasks_ShouldDisplayError() {
        let error = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Test error message"])
        
        presenter.didFailFetchingTasks(with: error)
        
        XCTAssertTrue(mockView.displayErrorCalled, "displayError was not called in view")
        XCTAssertEqual(mockView.displayedError, error.localizedDescription, "Displayed error message does not match")
    }
    
    func testDidUpdateTask_ShouldUpdateTaskInView() {
        let updatedTask = TaskEntity(id: 1, title: "Updated Task", todo: "Updated Todo", createdDate: Date(), completed: true)
        
        presenter.didUpdateTask(updatedTask)
        
        XCTAssertTrue(mockView.updateTaskCalled, "updateTask was not called in view")
        XCTAssertEqual(mockView.updatedTask?.id, updatedTask.id, "Updated task ID does not match")
        XCTAssertEqual(mockView.updatedTask?.title, updatedTask.title, "Updated task title does not match")
        XCTAssertEqual(mockView.updatedTask?.todo, updatedTask.todo, "Updated task todo does not match")
    }
}

final class MockInteractor: ToDoListInteractorInput {
    var fetchTasksCalled = false
    var addTaskCalled = false
    var updateTaskCalled = false
    var deleteTaskCalled = false
    var taskToAdd: TaskEntity?
    var taskToUpdate: TaskEntity?
    var taskIdToDelete: Int64?

    func fetchTasks() {
        fetchTasksCalled = true
    }

    func addTask(_ task: TaskEntity) {
        addTaskCalled = true
        taskToAdd = task
    }

    func updateTask(_ task: TaskEntity) {
        updateTaskCalled = true
        taskToUpdate = task
    }

    func deleteTask(by id: Int64) {
        deleteTaskCalled = true
        taskIdToDelete = id
    }
}

final class MockRouter: ToDoListRouterInput {
    var navigateToTaskDetailsCalled = false
    var taskToNavigate: TaskEntity?

    func navigateToTaskDetails(task: TaskEntity?) {
        navigateToTaskDetailsCalled = true
        taskToNavigate = task
    }
}

final class MockView: ToDoListViewInput {
    var displayTasksCalled = false
    var displayedTasks: [TaskEntity]?
    var displayErrorCalled = false
    var displayedError: String?
    var updateTaskCalled = false
    var updatedTask: TaskEntity?

    func displayTasks(_ tasks: [TaskEntity]) {
        displayTasksCalled = true
        displayedTasks = tasks
    }

    func displayError(_ errorMessage: String) {
        displayErrorCalled = true
        displayedError = errorMessage
    }

    func updateTask(_ task: TaskEntity) {
        updateTaskCalled = true
        updatedTask = task
    }

    func didAddNewTask(task: TaskEntity) { }
    
    func didEditTask(task: TaskEntity) { }
    
    func reloadData() { }
}
