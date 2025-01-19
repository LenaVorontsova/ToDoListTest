//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let session = URLSession.shared
    private let urlString = "https://dummyjson.com/todos"
    
    func fetchTodos(completion: @escaping (Result<[TaskEntity], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(TodoResponse.self, from: data)
                let toDoList = decoded.todos.map { task in
                    return TaskEntity(id: task.id,
                                      title: "Задача \(task.id ?? 0)",
                                      todo: task.todo,
                                      createdDate: Date(),
                                      completed: task.completed)
                }
                completion(.success(toDoList))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}
