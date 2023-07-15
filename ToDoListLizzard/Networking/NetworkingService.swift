//
//  NetworkingService.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 07.07.2023.
//

import Foundation

protocol NetworkingService {
    func getListRequest() async throws -> [TodoItem]
    func patchRequest(items: [TodoItem]) async throws -> [TodoItem]
    func getItemRequest(id: String) async throws -> TodoItem
    func postRequest(item: TodoItem) async throws
    func putRequest(item: TodoItem) async throws
    func deleteRequest(item: TodoItem) async throws
}
