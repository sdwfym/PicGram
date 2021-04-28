//
//  Enums & Structs.swift
//  DogGram
//
//  Created by Man Yuan on 04/06/2021.
//

import Foundation


struct DatabaseUserField { //Fields within the user document in database
    
    static let displayName = "display_name"
    static let email = "email"
    static let providerID = "provider_id"
    static let provider = "provider"
    static let userID = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"

}

struct DatabasePostField { //Fields within Post document in database
    
    static let postID = "post_id"
    static let userID = "user_id"
    static let displayName = "display_name"
    static let caption = "caption"
    static let dateCreated = "date_created"
    static let likeCount = "like_count" //Int
    static let likedBy = "liked_by" //array
    static let comments = "comments" //sub-collection
    
}

struct CurrentUserDefaults { //Fields for UserDefaults saved within app
    
    static let displayName = "display_name"
    static let bio = "bio"
    static let userID = "user_id"
    
}

struct DatabaseReportsField { //Fields within Report Document in Database
    
    static let content = "content"
    static let postID = "post_id"
    static let dateCreated = "date_created"
    
}

struct DatabaseCommentField { //Fields within the comment sub-collection of a post document
    static let commentID = "comment_id"
    static let displayName = "display_name"
    static let userID = "user_id"
    static let content = "content"
    static let dateCreated = "date_created"
}


enum SettingsEditTextOption {
    case displayName
    case bio
}

