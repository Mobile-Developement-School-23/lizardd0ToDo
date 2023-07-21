//
//  MockData.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 21.07.2023.
//

import Foundation


var listOfItems: [TodoItem] = [
    .init(text: "La-la-Land", importance: TodoItem.Importance.ordinary, deadline: Date(), flag: true),
    .init(text: "Pretty woman", importance: TodoItem.Importance.important, flag: false),
    .init(text: "No woman no cry", importance: TodoItem.Importance.unimportant, deadline: Date())
]

var defaultItem = TodoItem(text: "", importance: TodoItem.Importance.ordinary)
