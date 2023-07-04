//
//  Repository.swift
//  GITHUBGraphQL
//
//  Created by Abdalla El Najjar on 2023-07-03.
//

import Foundation

// MARK: - PurpleData


// MARK: - DataClass
struct GitHubResponse: Codable {
    let repository: Repository?
}

// MARK: - Repository
struct Repository: Codable {
    let name: String
    let description: String?
    let stargazers: Stargazers
}

// MARK: - Stargazers
struct Stargazers: Codable {
    let totalCount: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
