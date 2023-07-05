//
//  Repository.swift
//  GITHUBGraphQL
//
//  Created by Abdalla El Najjar on 2023-07-03.
//

import Foundation

struct Response: Codable {
    let data: RepositoryData
}

struct RepositoryData: Codable {
    let repository: Repository
}

struct Repository: Codable {
    let name: String
    let description: String?
    let stargazers: Stargazers
}

struct Stargazers: Codable {
    let totalCount: Int
}
