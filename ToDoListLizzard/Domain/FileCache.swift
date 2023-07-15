//
//  FileCache.swift
//  todolistYandex
//
//  Created by Елизавета Шерман on 28.06.2023.
//

import Foundation
import CoreData

class FileCache {
    private(set) var listofitems = [TodoItem]()
    
    init(listofitems: [TodoItem] = [TodoItem]()) {
        self.listofitems = listofitems
    }
    
    func additem(item: TodoItem) {
        if let findi = listofitems.map({$0.id}).firstIndex(of: item.id) {
            listofitems[findi] = item
        } else {
            listofitems.append(item)
        }
    }
    
    func deleteitem(id: String) {
        if let index = listofitems.map({$0.id}).firstIndex(of: id) {
            listofitems.remove(at: index)
        }
    }
    
    func readfromfileJSON(filename: String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(filename).json")
        var dateFromFile: Data?
        do {
            dateFromFile = try Data(contentsOf: fileURL)
        } catch {
            print("Ошибка получения Data: \(error.localizedDescription)")
            return
        }
        
        guard let data = dateFromFile else {
            print("Error! Невозможно распаковать data")
            return
        }
        
        var dictionary: [String: Any] = [:]
        do {
            guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Error! Невозможно преобразовать данные")
                return
            }
            dictionary = dict
        } catch {
            print("Ошибка парсинга: \(error.localizedDescription)")
            return
        }
        
        guard let todoitemsarray = dictionary["ToDoItem"] as? [[String: Any]] else {
            print("Error! Невозможно преобразовать данные")
            return
        }
        
        var array: [TodoItem] = []
        for todoitemsdict in todoitemsarray {
            if let item  = TodoItem.parse(json: todoitemsdict) {
                array.append(item)
            }
        }
        self.listofitems = array
    }
    
    func savetofileJSON(filename: String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(filename).json")
        var array: [Any] = []
        for item in listofitems {
            array.append(item.json)
        }
        do {
            let dict: [String: Any] = ["ToDoItem": array]
            let data = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
            try data.write(to: fileURL)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func readfromfileCSV(filename: String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(filename).csv")
       
        do {
            var array: [TodoItem] = []
            let csvarray = try String(contentsOf: fileURL).components(separatedBy: "\n")
            for item in csvarray {
                if let item  = TodoItem.parse(csv: item) {
                    array.append(item)
                }
            }
            self.listofitems = array
        } catch {
            print("Ошибка получения Data: \(error.localizedDescription)")
        }
        
    }
    
    
    func savetofileCSV(filename: String) {
        let str = "id,text,importance,deadline,flag,createdate,changedate"
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent("\(filename).csv")
        var array: [String] = [str]
        for item in listofitems {
            array.append(item.csv)
        }
        
        let strcsv = array.joined(separator: "\n")
        do {
            try strcsv.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func saveToDB() {
        let db = DataBase()
        for item in listofitems {
            db.insert(item: item.sqlReplaceStatement)
        }
    }
    
    func loadFromDB() {
        let db = DataBase()
            var array: [TodoItem] = []
            if let sqlItems = db.query()?.components(separatedBy: "\n") {
                for item in sqlItems {
                    if let item  = TodoItem.parse(sql: item) {
                        array.append(item)
                    }
                }
                self.listofitems = array
            } else {
                print("Ошибка получения Data")
            }
    }
    
    
    func saveToCoreData() {
        let coreData = CoreDataBase()
        for item in listofitems {
            coreData.insert(item: item)
        }
    }
    
    
    public func deleteAll() {
        listofitems.removeAll()
    }
    
    public func updateAllItems(with items: [TodoItem]){
        listofitems.append(contentsOf: items)
    }
}
