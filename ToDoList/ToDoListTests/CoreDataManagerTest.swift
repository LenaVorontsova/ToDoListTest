//
//  CoreDataManagerTest.swift
//  ToDoListTests
//
//  Created by Елена Воронцова on 21.01.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class CoreDataManagerTest: XCTestCase {
    var coreDataManager: CoreDataManager!
    var persistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: "ToDoList")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error, "Failed to load in-memory persistent store: \(String(describing: error))")
        }
        
        persistentContainer = container
        coreDataManager = CoreDataManager.shared
        coreDataManager.persistentContainer = persistentContainer
    }
    
    override func tearDown() {
        coreDataManager = nil
        persistentContainer = nil
        super.tearDown()
    }

    func testAddTaskSuccess() {
        let task = TaskEntity(id: 1,
                              title: "Test Task",
                              todo: "Complete Unit Tests",
                              createdDate: Date(),
                              completed: false)
        
        coreDataManager.addTask(task)
        let tasks = coreDataManager.fetchTasks()
        
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.id, task.id)
        XCTAssertEqual(tasks.first?.title, task.title)
        XCTAssertEqual(tasks.first?.todo, task.todo)
        XCTAssertEqual(tasks.first?.completed, task.completed)
    }

    func testFetchTasksEmpty() {
        let tasks = coreDataManager.fetchTasks()
        
        XCTAssertEqual(tasks.count, 0, "Fetch tasks should return an empty array when there are no tasks")
    }

    func testUpdateTaskSuccess() {
        let initialTask = TaskEntity(id: 1,
                                     title: "Initial Task",
                                     todo: "Initial Todo",
                                     createdDate: Date(),
                                     completed: false)
        coreDataManager.addTask(initialTask)
        
        let updatedTask = TaskEntity(id: 1,
                                     title: "Updated Task",
                                     todo: "Updated Todo",
                                     createdDate: Date(),
                                     completed: true)
        
        coreDataManager.updateTask(updatedTask)
        let tasks = coreDataManager.fetchTasks()
        
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.id, updatedTask.id)
        XCTAssertEqual(tasks.first?.title, updatedTask.title)
        XCTAssertEqual(tasks.first?.todo, updatedTask.todo)
        XCTAssertEqual(tasks.first?.completed, updatedTask.completed)
    }

    func testUpdateTaskNonExistent() {
        let nonExistentTask = TaskEntity(id: 999,
                                         title: "Non-existent Task",
                                         todo: "Should not update",
                                         createdDate: Date(),
                                         completed: false)
        
        coreDataManager.updateTask(nonExistentTask)
        let tasks = coreDataManager.fetchTasks()
        
        XCTAssertEqual(tasks.count, 0, "Updating a non-existent task should not create new entries")
    }
    
    func testDeleteTaskSuccess() {
        let task = TaskEntity(id: 1, title: "Task to Delete", todo: "Delete this task", createdDate: Date(), completed: false)
        coreDataManager.addTask(task)
        
        coreDataManager.deleteTask(by: task.id!)
        let tasks = coreDataManager.fetchTasks()
        
        XCTAssertEqual(tasks.count, 0, "Task should be deleted successfully")
    }

    func testDeleteTaskNonExistent() {
        let nonExistentTaskId: Int64 = 999
        
        coreDataManager.deleteTask(by: nonExistentTaskId)
        let tasks = coreDataManager.fetchTasks()
        
        XCTAssertEqual(tasks.count, 0, "Deleting a non-existent task should not affect other data")
    }
    
    func testSaveFetchedTasksSuccess() {
        let tasksToSave = [
            TaskEntity(id: 1, title: "Task 1", todo: "Todo 1", createdDate: Date(), completed: false),
            TaskEntity(id: 2, title: "Task 2", todo: "Todo 2", createdDate: Date(), completed: true)
        ]
        
        coreDataManager.saveFetchedTasks(tasksToSave)
        let tasks = coreDataManager.fetchTasks()
        
        XCTAssertEqual(tasks.count, tasksToSave.count)
        XCTAssertEqual(tasks[0].id, tasksToSave[0].id)
        XCTAssertEqual(tasks[1].id, tasksToSave[1].id)
    }
}
