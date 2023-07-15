//
//  TodoItemCore+CoreDataProperties.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 15.07.2023.
//
//

import Foundation
import CoreData


extension TodoItemCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItemCoreData> {
        return NSFetchRequest<TodoItemCoreData>(entityName: "TodoItemCore")
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var importance: String?
    @NSManaged public var deadline: Int32
    @NSManaged public var flag: Bool
    @NSManaged public var color: String?
    @NSManaged public var createdate: Int32
    @NSManaged public var changedate: Int32
    @NSManaged public var lastupdatedby: String?

}

extension TodoItemCoreData : Identifiable {

}
