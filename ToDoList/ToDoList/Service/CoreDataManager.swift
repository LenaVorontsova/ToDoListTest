//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Fetch Tasks
    func fetchTasks() -> [TaskEntity] {
        let fetchRequest: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        do {
            let tasks = try context.fetch(fetchRequest)
            
            return tasks.map { task in
                TaskEntity(id: task.id,
                           title: task.title,
                           todo: task.todo,
                           createdDate: task.createdDate,
                           completed: task.completed)
            }
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    // MARK: - Save Fetched Tasks
    func saveFetchedTasks(_ tasks: [TaskEntity]) {
        tasks.forEach { addTask($0) }
    }
    
    // MARK: - Add Task
    func addTask(_ task: TaskEntity) {
        let newTask = ToDoList(context: context)
        newTask.id = Int64(task.id ?? 0)
        newTask.title = task.title
        newTask.todo = task.todo
        newTask.createdDate = task.createdDate
        newTask.completed = task.completed ?? false
        
        saveContext()
    }

    // MARK: - Update Task
    func updateTask(_ task: TaskEntity) {
        let fetchRequest: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", (task.id ?? 0))
        do {
            let tasks = try context.fetch(fetchRequest)
            if let existingTask = tasks.first {
                existingTask.title = task.title
                existingTask.todo = task.todo
                existingTask.createdDate = task.createdDate
                existingTask.completed = task.completed ?? false
                saveContext()
            }
        } catch {
            print("Failed to update task: \(error)")
        }
    }
    
    // MARK: - Delete Task
    func deleteTask(by id: Int64) {
        let fetchRequest: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            for task in tasks {
                context.delete(task)
            }
            saveContext()
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
}
