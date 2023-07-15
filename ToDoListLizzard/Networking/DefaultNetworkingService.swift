//
//  DefaultNetworkingService.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 07.07.2023.
//

import Foundation

class DefaultNetworkingService: NetworkingService {
    private let token = "duali"
    private let baseURL = "https://beta.mrdekk.ru/todobackend"
    private(set) var revision: Int32 = 0
    private let urlSession = URLSession.shared
    var isDirty = false
    
    
    func getListRequest() async throws -> [TodoItem] {
        guard let url = URL(string: "\(baseURL)/list") else {
            throw NetworkingError.wrongURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)"]
        let (data, response) = try await urlSession.data(for: request)
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode >= 500 &&  response.statusCode < 600{
                isDirty = true
                throw NetworkingError.unexpectedResponse(response)
            }
        }
        let newData = try JSONDecoder().decode(ResponseList.self, from: data)
        if let rev = newData.revision {
            self.revision = rev
        }
        return newData.list.map({$0.serviceItemToClassic()})
    }
    
    
    func patchRequest(items: [TodoItem]) async throws -> [TodoItem] {
        guard let url = URL(string: "\(baseURL)/list") else {
            throw NetworkingError.wrongURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(self.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let serviceList = items.map({ServiceTodoIem(item: $0)})
        let responseList = ResponseList(list: serviceList)
        let body = try JSONEncoder().encode(responseList)
        request.httpBody = body
        let (data, response) = try await urlSession.data(for: request)
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 400 {
                isDirty = true
                throw NetworkingError.failedResponse(response)
            } else if response.statusCode == 500 {
                isDirty = true
                throw NetworkingError.unexpectedResponse(response)
            }
        }
        let newData = try JSONDecoder().decode(ResponseList.self, from: data)
        if let rev = newData.revision {
            self.revision = rev
        }
        
        return newData.list.map({$0.serviceItemToClassic()})
    }
    
    
    func getItemRequest(id: String) async throws -> TodoItem {
        guard let url = URL(string: "\(baseURL)/list/\(id)") else {
            throw NetworkingError.wrongURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(self.token)"]
        let (data, response) = try await urlSession.data(for: request)
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 500 {
                isDirty = true
                throw NetworkingError.unexpectedResponse(response)
            }
        }
        let newData = try JSONDecoder().decode(ResponseItem.self, from: data)
        if let rev = newData.revision {
            self.revision = rev
        }
        return newData.element.serviceItemToClassic()
    }
    
    func postRequest(item: TodoItem) async throws {
        guard let url = URL(string: "\(baseURL)/list") else {
            throw NetworkingError.wrongURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(self.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let element = ServiceTodoIem(item: item)
        let responseItem = ResponseItem(element: element)
        let body = try JSONEncoder().encode(responseItem)
        
        request.httpBody = body
        
        let (data, response) = try await urlSession.data(for: request)
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 400 {
                isDirty = true
                throw NetworkingError.failedResponse(response)
            } else if response.statusCode == 500 {
                isDirty = true
                throw NetworkingError.unexpectedResponse(response)
            }
        }
        let newData = try JSONDecoder().decode(ResponseItem.self, from: data)
        if let rev = newData.revision {
            self.revision = rev
        }
    }
    
    func putRequest(item: TodoItem) async throws {
        guard let url = URL(string: "\(baseURL)/list/\(item.id)") else {
            throw NetworkingError.wrongURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(self.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let element = ServiceTodoIem(item: item)
        let responseItem = ResponseItem(element: element)
        let body = try JSONEncoder().encode(responseItem)
        
        request.httpBody = body
        let (data, response) = try await urlSession.data(for: request)
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 400 {
                isDirty = true
                throw NetworkingError.failedResponse(response)
            } else if response.statusCode == 404 {
                isDirty = true
                throw NetworkingError.notFound
            } else if response.statusCode == 500 {
                isDirty = true
                throw NetworkingError.unexpectedResponse(response)
            }
        }
        
        let newData = try JSONDecoder().decode(ResponseItem.self, from: data)
        if let rev = newData.revision {
            self.revision = rev
        }
        
    }
    
    func deleteRequest(item: TodoItem) async throws {
        guard let url = URL(string: "\(baseURL)/list/\(item.id)") else {
            throw NetworkingError.wrongURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(self.revision)", forHTTPHeaderField: "X-Last-Known-Revision")

        
        let element = ServiceTodoIem(item: item)
        let responseItem = ResponseItem(element: element)
        let body = try JSONEncoder().encode(responseItem)
        
        request.httpBody = body
        let (data, response) = try await urlSession.data(for: request)
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 400 {
                isDirty = true
                throw NetworkingError.failedResponse(response)
            } else if response.statusCode == 404 {
                isDirty = true
                throw NetworkingError.notFound
            } else if response.statusCode == 500 {
                isDirty = true
                throw NetworkingError.unexpectedResponse(response)
            }
        }
        
        let newData = try JSONDecoder().decode(ResponseItem.self, from: data)
        if let rev = newData.revision {
            self.revision = rev
        }
    }
    
    
}
