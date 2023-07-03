//
//  Repository.swift
//  GITHUBGraphQL
//
//  Created by Abdalla El Najjar on 2023-07-03.
//

class Repository: Identifiable {
    let id: String
    let name: String
    let description: String?
    let stargazerCount: Int
    
    init(id: String, name: String, description: String?, stargazerCount: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.stargazerCount = stargazerCount
    }
}
