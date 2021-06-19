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
    let id, thumbID, ownerID: Int?
    let title, itemDescription: String?
//    let created, updated, size, thumbIsLast: Int?
//    let privacyView, privacyComment: Privacy?

    enum CodingKeys: String, CodingKey {
        case id
        case thumbID = "thumb_id"
        case ownerID = "owner_id"
        case title
        case itemDescription = "description"
//        case created, updated, size
//        case thumbIsLast = "thumb_is_last"
//        case privacyView = "privacy_view"
//        case privacyComment = "privacy_comment"
    }
}

//// MARK: - Privacy
//struct Privacy: Codable {
//    let category: Category?
//}
//
//enum Category: String, Codable {
//    case friends = "friends"
//    case onlyMe = "only_me"
//}
