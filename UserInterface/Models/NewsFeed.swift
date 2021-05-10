//
//  NewsFeed.swift
//  UserInterface
//
//  Created by Ilya on 05.05.2021.
//

import Foundation

class NewsFeed {
    //    let id: Int
    let ownerId: Int
    var ownerName: String
    var ownerAvatar: String
    let date: String
    let text: String?
    let photoContent: String?
    let likes: Likes?
    let reposts: Reposts?
    let comments: Comments?
    let views: Views?
    
    init(ownerId: Int,
         ownerName: String = "",
         ownerAvatar: String = "",
         date: String,
         text: String?,
         photoContent: String?,
         likes: Likes?,
         reposts: Reposts?,
         comments: Comments?,
         views: Views?) {
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.ownerAvatar = ownerAvatar
        self.date = date
        self.text = text
        self.photoContent = photoContent
        self.likes = likes
        self.reposts = reposts
        self.comments = comments
        self.views = views
    }
}

class NewsFeedVK: Codable {
    let response: NewsFeedResponse
}

class NewsFeedResponse: Codable {
    let items: [NewsFeedItem]
    let profiles: [FriendItem]
    let groups: [GroupItem]
    //let nextFrom: String
    
    //    enum CodingKeys: String, CodingKey {
    //        case items, profiles, groups
    //        case nextFrom = "next_from"
    //    }
}

class NewsFeedItem: Codable {
    let sourceID, date: Int
    //    let canDoubtCategory, canSetCategory: Bool
    let postType, text: String?
    //    let markedAsAds: Int
    let attachments: [Attachment]?
    //    let postSource: PostSource
    let comments: Comments?
    let likes: Likes?
    let reposts: Reposts?
    let views: Views?
    //    let isFavorite: Bool
    //    let donut: Donut
    //    let shortTextRate: Double
    //    let carouselOffset, postID: Int
    //    let type: String
    
    enum CodingKeys: String, CodingKey {
        case sourceID = "source_id"
        case date
        //        case canDoubtCategory = "can_doubt_category"
        //        case canSetCategory = "can_set_category"
        case postType = "post_type"
        case text
        //        case markedAsAds = "marked_as_ads"
        case attachments
        //        case postSource = "post_source"
        case comments, likes, reposts, views
        //        case isFavorite = "is_favorite"
        //        case donut
        //        case shortTextRate = "short_text_rate"
        //        case carouselOffset = "carousel_offset"
        //        case postID = "post_id"
        //        case type
    }
}



class Attachment: Codable {
    var type: String?
    var photo: Photo?
    var link: Link?
    var podcast: Podcast?
    var video: Video?
    var audio: Audio?
    
    class Audio: Codable {
        let artist: String?
        let id, ownerID: Int?
        let title: String?
        let duration: Int?
        let isExplicit, isFocusTrack: Bool?
        let trackCode: String
        let url: String?
        let date: Int?
        let mainArtists: [MainArtist]?
        let shortVideosAllowed, storiesAllowed, storiesCoverAllowed: Bool?
        let genreID: Int?
        
        enum CodingKeys: String, CodingKey {
            case artist, id
            case ownerID = "owner_id"
            case title, duration
            case isExplicit = "is_explicit"
            case isFocusTrack = "is_focus_track"
            case trackCode = "track_code"
            case url, date
            case mainArtists = "main_artists"
            case shortVideosAllowed = "short_videos_allowed"
            case storiesAllowed = "stories_allowed"
            case storiesCoverAllowed = "stories_cover_allowed"
            case genreID = "genre_id"
        }
    }
    
    class MainArtist: Codable {
        let name, domain, id: String?
    }
    
    class Photo: Codable {
        let albumID, date, id, ownerID: Int?
        let hasTags: Bool?
        let accessKey: String?
        let postID: Int?
        let sizes: [Size]?
        let text: String?
        let userID: Int?
        
        enum CodingKeys: String, CodingKey {
            case albumID = "album_id"
            case date, id
            case ownerID = "owner_id"
            case hasTags = "has_tags"
            case accessKey = "access_key"
            case postID = "post_id"
            case sizes, text
            case userID = "user_id"
        }
    }
    
    // MARK: - Size
    class Size: Codable {
        let height: Int?
        let url: String?
        let type: String?
        let width: Int?
    }
    
    
    class Video: Codable {
        var accessKey: String?
        var date: Int64?
        var description: String?
        var id: Int?
        var ownerId: Int?
        var title: String?
        var trackCode: String?
        var platform: String?
        var image: [Size]?
        
        enum CodingKeys: String, CodingKey {
            case accessKey = "access_key"
            case date
            case description
            case id
            case ownerId = "owner_id"
            case title
            case trackCode = "track_code"
            case platform
            case image
        }
    }
    
    class Podcast: Codable {
        var artist: String?
        var id: Int?
        var ownerId: Int?
        var title: String?
        var trackCode: String?
        var url: String?
        var date: Int64?
        var podcastInfo: PodcastInfo?
        
        enum CodingKeys: String, CodingKey {
            case artist
            case id
            case ownerId = "owner_id"
            case title
            case trackCode = "track_ode"
            case url
            case date
            case podcastInfo = "podcast_info"
        }
        
        
        class PodcastInfo: Codable {
            var cover: PodcastCover?
            
            class PodcastCover: Codable {
                var sizes: [Size]?
            }
        }
    }
    
    class Link: Codable {
        var url: String?
        var title: String?
        var caption: String?
        var description: String?
        var photo: Photo?
        
        enum CodingKeys: String, CodingKey {
            case url
            case title
            case caption
            case description
            case photo
        }
    }
}

// MARK: - Comments
class Comments: Codable {
    let count, canPost: Int?
    let groupsCanPost: Bool?
    
    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
        case groupsCanPost = "groups_can_post"
    }
}

// MARK: - Donut
class Donut: Codable {
    let isDonut: Bool?
    
    enum CodingKeys: String, CodingKey {
        case isDonut = "is_donut"
    }
}

// MARK: - Likes
class Likes: Codable {
    let count, userLikes, canLike, canPublish: Int?
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
}

class PostSource: Codable {
    let type: String?
}

class Reposts: Codable {
    let count, userReposted: Int?
    
    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

class Views: Codable {
    let count: Int?
}

class OnlineInfo: Codable {
    let visible, isOnline, isMobile: Bool?
    
    enum CodingKeys: String, CodingKey {
        case visible
        case isOnline = "is_online"
        case isMobile = "is_mobile"
    }
}
