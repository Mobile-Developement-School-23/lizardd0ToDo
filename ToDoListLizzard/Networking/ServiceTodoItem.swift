//
//  ServiceTodoItem.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 07.07.2023.
//

import Foundation
import UIKit

struct ServiceTodoIem: Codable {
    let id: String
    let text: String
    let importance: String
    let deadline: Int?
    let flag: Bool
    let color: String?
    let createdate: Int
    let changedate: Int?
    let lastupdatedby: String

    init(item: TodoItem) {
        self.id = item.id
        self.text = item.text
        self.importance = item.importance.rawValue
        self.deadline = item.deadline.flatMap { Int($0.timeIntervalSince1970) }
        self.flag = item.flag
        self.color = nil
        self.createdate = Int(item.createdate.timeIntervalSince1970)
        self.changedate = Int((item.changedate ?? item.createdate).timeIntervalSince1970)
        self.lastupdatedby = UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case flag = "done"
        case color
        case createdate = "created_at"
        case changedate = "changed_at"
        case lastupdatedby = "last_updated_by"
    }
    
    func serviceItemToClassic() -> TodoItem {
        var importance: TodoItem.Importance
        switch self.importance {
        case "low": importance = TodoItem.Importance.unimportant
        case "basic": importance = TodoItem.Importance.ordinary
        case "important": importance = TodoItem.Importance.important
        default: importance = TodoItem.Importance.ordinary
        }
        var deadline: Date?
        if let intdate = self.deadline {
            deadline = Date(timeIntervalSince1970: TimeInterval(intdate))
        }
        let createdate = Date(timeIntervalSince1970: TimeInterval(self.createdate))
        var changedate: Date?
        if let intdate = self.changedate {
            changedate = Date(timeIntervalSince1970: TimeInterval(intdate))
        }
        let todoitem = TodoItem(id: self.id, text: self.text, importance: importance, deadline: deadline, flag: self.flag, createdate: createdate, changedate: changedate)
        return todoitem
    }
    
    

}

struct ResponseList: Codable {
    var status: String?
    var list = [ServiceTodoIem]()
    var revision: Int32?
    
    init(status: String? = nil, list: [ServiceTodoIem], revision: Int32? = nil) {
        self.status = status
        self.list = list
        self.revision = revision
    }
}

struct ResponseItem: Codable {
    var status: String?
    var element: ServiceTodoIem
    var revision: Int32?
    
    init(status: String? = nil, element: ServiceTodoIem, revision: Int32? = nil) {
        self.status = status
        self.element = element
        self.revision = revision
    }
}


enum NetworkingError: Error {
    case wrongURL
    case unexpectedResponse(URLResponse)
    case failedResponse(HTTPURLResponse)
    case notFound
}
