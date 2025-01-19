//
//  ToDoList+CoreDataProperties.swift
//  ToDoList
//
//  Created by Елена Воронцова on 19.01.2025.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var todo: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var completed: Bool

}

extension ToDoList : Identifiable {

}
