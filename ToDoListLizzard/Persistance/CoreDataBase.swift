//
//  CoreData.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 15.07.2023.
//

import Foundation
import CoreData
import UIKit

public final class CoreDataBase {
    public static let shared = CoreDataBase()
    private var itemsCoreData = [TodoItemCoreData]()
    private var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
    func insert(item: TodoItem) {
        if let index = itemsCoreData.firstIndex(where: {item.id == $0.id}) {
            if let item = item.coreData {
                itemsCoreData[index] = item
            }
        } else {
            if let item = item.coreData {
                itemsCoreData.append(item)
            }
        }
        do {
            if let context = context {
                try context.save()
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func delete(id: String) {
        var index: Int?
        for identifier in (0..<itemsCoreData.count) where itemsCoreData[identifier].id == id {
            index = identifier
        }
        if let index = index {
            if let context = context {
                context.delete(itemsCoreData[index])
                itemsCoreData.remove(at: index)
            }
        }
        do {
            if let context = context {
                try context.save()
            }
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func query() -> [TodoItem] {
        var collectionsOfToDoItems = [TodoItem]()
        let request: NSFetchRequest<TodoItemCoreData> = TodoItemCoreData.fetchRequest()
        do {
            if let context = context {
                itemsCoreData = try context.fetch(request)
                for item in itemsCoreData {
                    if let convertedItem = TodoItem.parse(coreItem: item) {
                        collectionsOfToDoItems.append(convertedItem)
                    }
                }
            }
        } catch {
            print("Error loading context \(error)")
        }
        return collectionsOfToDoItems
    }

    func deleteAllData() {
        if let context = context {
            for item in itemsCoreData {
                context.delete(item)
            }
            
        }
    }
}
