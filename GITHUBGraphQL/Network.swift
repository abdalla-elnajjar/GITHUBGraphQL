//
//  Network.swift
//  GITHUBGraphQL
//
//  Created by Abdalla El Najjar on 2023-07-03.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case statusCode(Int)
    case noData
}

func sendGraphQLRequest(url: URL, query: String, token: String, completion: @escaping (Result<Data, Error>) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let requestBody = ["query": query]
    request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print(error)
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(NetworkError.statusCode(httpResponse.statusCode)))
            return
        }
        
        guard let responseData = data else {
            completion(.failure(NetworkError.noData))
            return
        }
        
        completion(.success(responseData))
    }
    
    task.resume()
}

