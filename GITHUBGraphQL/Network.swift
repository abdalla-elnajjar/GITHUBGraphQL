//
//  Network.swift
//  GITHUBGraphQL
//
//  Created by Abdalla El Najjar on 2023-07-03.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case statusCode(Int)
    case noData
    case encodingError
}

struct GraphQLRequestBody: Codable {
    let query: String
}

func sendGraphQLRequest(url: URL, query: String, token: String, completion: @escaping (Result<GitHubResponse, Error>) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let requestBody = GraphQLRequestBody(query: query)
    let jsonEncoder = JSONEncoder()
    
    guard let encodedRequestBody = try? jsonEncoder.encode(requestBody) else {
        completion(.failure(NetworkError.encodingError))
        return
    }
    
    request.httpBody = encodedRequestBody
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
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
        
        do {
            
            let decoder = JSONDecoder()
            let repositories = try decoder.decode(GitHubResponse.self, from: responseData)
            completion(.success(repositories))
        } catch {
            
            completion(.failure(error))
        }
    }
    
    task.resume()
}
