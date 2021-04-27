//
//  Photos.swift
//  UserInterface
//
//  Created by Ilya on 27.03.2021.
//


import Foundation
import RealmSwift

// MARK: - Welcome
struct Photos: Codable {
    let response: PhotosResponse
}

struct PhotosResponse: Codable {
    let count: Int
    let items: [PhotoItem]
}

// MARK: - Item
class PhotoItem: Object, Codable {
    @objc dynamic var albumID: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerID: Int = 0
    var sizes = List<Size>()
    @objc dynamic var text: String = ""
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case sizes, text
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? PhotoItem {
            return self.albumID == object.albumID && self.text == object.text
        } else {
            return false
        }
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
}

// MARK: - Size
class Size: Object, Codable {
    @objc dynamic var height: Int = 0
    @objc dynamic var url: String = ""
    var type: TypeEnum
    @objc dynamic var width: Int = 0
}

enum TypeEnum: String, Codable {
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}

enum TypeAlbum: String {
    case wall = "wall"  //фото со стены
    case profile = "profile" //фотографии профиля
    case saved = "saved" //сохраненные фотографии.
}

enum TypeRev: Int {
    case chronological = 0
    case antiСhronological = 1
}
