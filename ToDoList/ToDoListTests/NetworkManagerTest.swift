//
//  NetworkManagerTest.swift
//  ToDoListTests
//
//  Created by Елена Воронцова on 21.01.2025.
//

import XCTest
@testable import ToDoList

final class NetworkManagerTest: XCTestCase {
    private var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        
        networkManager = NetworkManager.shared
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func testFetchTodosSuccess() {
        let expectation = self.expectation(description: "Fetch todos successfully")
        
        networkManager.fetchTodos { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, 30)
                XCTAssertEqual(tasks[0].id, 1)
                XCTAssertEqual(tasks[0].todo, "Do something nice for someone you care about")
                XCTAssertEqual(tasks[0].completed, false)
                XCTAssertEqual(tasks[1].id, 2)
                XCTAssertEqual(tasks[1].todo, "Memorize a poem")
                XCTAssertEqual(tasks[1].completed, true)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testFetchTodosInvalidURL() {
        networkManager.setNewURL("")
        let expectation = self.expectation(description: "Invalid URL error")
        
        networkManager.fetchTodos { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "Invalid URL")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchTodosDecodingError() {
        networkManager.setNewURL("https://newsapi.org/v2/everything?q=tesla&from=2024-12-21&sortBy=publishedAt&apiKey=e5642ec49a244ad98f0a81772729d70c")
        let expectation = self.expectation(description: "Decoding error")
        networkManager.fetchTodos { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure:
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
