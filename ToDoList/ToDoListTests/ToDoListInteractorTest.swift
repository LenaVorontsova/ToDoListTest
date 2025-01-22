//
//  ToDoListInteractorTest.swift
//  ToDoListTests
//
//  Created by Елена Воронцова on 21.01.2025.
//

import XCTest
@testable import ToDoList

final class ToDoListInteractorTest: XCTestCase {
    var interactor: ToDoListInteractor!
    var mockPresenter: MockPresenter!
    var mockCoreDataManager: MockCoreDataManager!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockPresenter()
        mockCoreDataManager = MockCoreDataManager()
        mockNetworkManager = MockNetworkManager()
        
        interactor = ToDoListInteractor()
        interactor.presenter = mockPresenter
        interactor.setupManagers(network: mockNetworkManager, coreData: mockCoreDataManager)
    }
    
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockCoreDataManager = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testFetchTasks_WithSavedTasks_ShouldReturnTasks() {
        let tasks = [
            TaskEntity(id: 1, title: "Task 1", todo: "Todo 1", createdDate: Date(), completed: false)
        ]
        mockCoreDataManager.mockTasks = tasks
        
        interactor.fetchTasks()
        
        XCTAssertTrue(mockPresenter.didFetchTasksCalled)
        XCTAssertEqual(mockPresenter.fetchedTasks?.count, tasks.count)
    }
    
    func testFetchTasks_WithoutSavedTasks_ShouldFetchFromNetwork() {
        mockCoreDataManager.mockTasks = []
        let networkTasks = [
            TaskEntity(id: 2, title: "Task 2", todo: "Todo 2", createdDate: Date(), completed: true)
        ]
        mockNetworkManager.result = .success(networkTasks)
        let expectation = XCTestExpectation(description: "Fetch tasks from network")
        
        
        interactor.fetchTasks()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockPresenter.didFetchTasksCalled)
            XCTAssertEqual(self.mockPresenter.fetchedTasks?.count, networkTasks.count)
            XCTAssertTrue(self.mockCoreDataManager.saveFetchedTasksCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchTasks_NetworkFailure_ShouldReturnError() {
        mockCoreDataManager.mockTasks = []
        let networkError = NSError(domain: "Network", code: 500, userInfo: nil)
        mockNetworkManager.result = .failure(networkError)
        let expectation = XCTestExpectation(description: "Fetch tasks fails with error")
        
        interactor.fetchTasks()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockPresenter.didFailFetchingTasksCalled)
            XCTAssertEqual(self.mockPresenter.fetchError as NSError?, networkError)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddTask_ShouldAddAndFetchTasks() {
        let newTask = TaskEntity(id: 3, title: "New Task", todo: "Do something", createdDate: Date(), completed: false)
        let expectation = XCTestExpectation(description: "Task is added and fetched")
        
        
        interactor.addTask(newTask)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockCoreDataManager.addTaskCalled)
            XCTAssertEqual(self.mockCoreDataManager.addedTask?.id, newTask.id)
            XCTAssertTrue(self.mockPresenter.didFetchTasksCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateTask_ShouldUpdateAndFetchTasks() {
        let existingTask = TaskEntity(id: 1, title: "Old Task", todo: "Old Todo", createdDate: Date(), completed: false)
        let updatedTask = TaskEntity(id: 1, title: "Updated Task", todo: "Updated Todo", createdDate: Date(), completed: true)
        mockCoreDataManager.mockTasks = [existingTask]
        
        let expectation = XCTestExpectation(description: "Task is updated and presenter is notified")

        interactor.updateTask(updatedTask)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertTrue(self.mockPresenter.didUpdateTaskCalled, "didUpdateTask was not called")
            
            XCTAssertEqual(self.mockPresenter.updatedTask?.title, "Updated Task", "Task title was not updated correctly")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteTask_ShouldDeleteAndFetchTasks() {
        let taskId: Int64 = 1
        let expectation = XCTestExpectation(description: "Task is deleted and fetched")
        mockCoreDataManager.mockTasks = [
            TaskEntity(id: 1, title: "Task 1", todo: "Todo 1", createdDate: Date(), completed: false)
        ]
        
        interactor.deleteTask(by: taskId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertTrue(self.mockCoreDataManager.deleteTaskCalled, "deleteTask was not called")
            XCTAssertEqual(self.mockCoreDataManager.deletedTaskId, taskId, "Deleted task ID does not match")
            XCTAssertTrue(self.mockPresenter.didFetchTasksCalled, "didFetchTasks was not called in the presenter")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testUpdateTask_ShouldUpdateAndNotifyPresenter() {
        let existingTask = TaskEntity(id: 1, title: "Old Task", todo: "Old Todo", createdDate: Date(), completed: false)
        let updatedTask = TaskEntity(id: 1, title: "Updated Task", todo: "Updated Todo", createdDate: Date(), completed: true)
        mockCoreDataManager.mockTasks = [existingTask]
        let expectation = XCTestExpectation(description: "Task is updated and presenter is notified")

        interactor.updateTask(updatedTask)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockCoreDataManager.updateTaskCalled, "updateTask was not called")
            XCTAssertEqual(self.mockCoreDataManager.updatedTask?.id, updatedTask.id, "The ID of the updated issue does not match")
            
            XCTAssertTrue(self.mockPresenter.didUpdateTaskCalled, "didUpdateTask was not called in the presenter")
            XCTAssertEqual(self.mockPresenter.updatedTask?.title, "Updated Task", "The name of the updated task does not match")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}

final class MockPresenter: ToDoListInteractorOutput {
    var didFetchTasksCalled = false
    var fetchedTasks: [TaskEntity]?

    var didFailFetchingTasksCalled = false
    var fetchError: Error?

    var didUpdateTaskCalled = false
    var updatedTask: TaskEntity?

    func didFetchTasks(_ tasks: [TaskEntity]) {
        didFetchTasksCalled = true
        fetchedTasks = tasks
    }

    func didFailFetchingTasks(with error: Error) {
        didFailFetchingTasksCalled = true
        fetchError = error
    }

    func didUpdateTask(_ task: TaskEntity) {
        didUpdateTaskCalled = true
        updatedTask = task
    }
}

final class MockCoreDataManager: CoreDataManagerProtocol {
    var mockTasks: [TaskEntity] = []
    var addTaskCalled = false
    var addedTask: TaskEntity?
    
    var updateTaskCalled = false
    var updatedTask: TaskEntity?
    
    var deleteTaskCalled = false
    var deletedTaskId: Int64?
    
    var saveFetchedTasksCalled = false
    
    func fetchTasks() -> [TaskEntity] {
        print("MockCoreDataManager: fetchTasks called")
        return mockTasks
    }

    func addTask(_ task: TaskEntity) {
        addTaskCalled = true
        addedTask = task
        mockTasks.append(task)
        print("MockCoreDataManager: addTask called with \(task)")
    }

    func updateTask(_ task: TaskEntity) {
        updateTaskCalled = true
        updatedTask = task
        if let index = mockTasks.firstIndex(where: { $0.id == task.id }) {
            mockTasks[index] = task
        }
        print("MockCoreDataManager: updateTask called with \(task)")
    }

    func deleteTask(by id: Int64) {
        deleteTaskCalled = true
        deletedTaskId = id
    }

    func saveFetchedTasks(_ tasks: [TaskEntity]) {
        saveFetchedTasksCalled = true
    }
}

final class MockNetworkManager: NetworkManagerProtocol {
    var result: Result<[TaskEntity], Error>?

    func fetchTodos(completion: @escaping (Result<[TaskEntity], Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}

