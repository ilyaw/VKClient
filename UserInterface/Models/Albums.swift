//
//  Albums.swift
//  UserInterface
//
//  Created by Ilya on 19.06.2021.
//

import Foundation

// MARK: - Welcome
struct Albums: Codable {
    let response: AlbumsResponse
}

// MARK: - Response
struct AlbumsResponse: Codable {
    let count: Int
    let items: [AlbumItem]
}

// MARK: - Item
struct AlbumItem: Codable {
    let id, thumbID, ownerID, size: Int?
    let title, itemDescription: String?

    enum CodingKeys: String, CodingKey {
        case id
        case thumbID = "thumb_id"
        case ownerID = "owner_id"
        case title
        case itemDescription = "description"
        case size
    }
}
