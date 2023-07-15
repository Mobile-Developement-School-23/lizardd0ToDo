//
//  URLSession.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 06.07.2023.
//

import Foundation


extension URLSession {
    func data(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var task: URLSessionDataTask?
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                task = self.dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data,
                              let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        continuation.resume(throwing: URLError(.unknown))
                    }
                }
                task?.resume()
            }
        } onCancel: {
            [weak task] in task?.cancel()
        }
    }
}
