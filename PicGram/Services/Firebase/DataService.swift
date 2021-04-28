//
//  DataService.swift
//  DogGram
//
//  Created by Man Yuan on 04/06/2021.
//


//Used to handle upload and download data (other than User) from our Database
import Foundation
import SwiftUI
import FirebaseFirestore


class DataService {
    //MARK: PROPERTIES
    
    static let instance = DataService()
    private var REF_POSTS = DB_BASE.collection("posts")
    private var REF_REPORTS = DB_BASE.collection("reports")
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    //MARK: CREATE FUNCTIONS
    
    func uploadPost(image: UIImage, caption: String?, displayName: String, userID: String, handler: @escaping(_ success: Bool) -> ()) {
        // Create new  post document
        let document = REF_POSTS.document()
        let postID = document.documentID
        
        //Upload image to storage
        ImageManager.instance.uploadPostImage(postID: postID, image: image) { (success) in
            if success {
                //successfully uploaded image data to Storage
                //Now uplaod post data to Database
                let postData: [String: Any] = [
                    DatabasePostField.postID : postID,
                    DatabasePostField.userID : userID,
                    DatabasePostField.displayName : displayName,
                    DatabasePostField.caption : caption,
                    DatabasePostField.dateCreated : FieldValue.serverTimestamp()
                    
                ]
                
                document.setData(postData) { (error) in
                    if let error = error {
                        print("error uploading data to post document. \(error)")
                        handler(false)
                        return
                    } else {
                        // return back to the app
                        handler(true)
                        return
                    }
                    
                }
                
                
                
            } else {
                print("Error uploading post image to firebase")
                handler(false)
                return
            }
        }
    }
    
    func uploadReport(reason: String, postID: String, handler: @escaping(_ success: Bool) -> ()) {
        
        let data: [String: Any] = [
            DatabaseReportsField.content : reason,
            DatabaseReportsField.postID : postID,
            DatabaseReportsField.dateCreated : FieldValue.serverTimestamp()
        ]
        
        REF_REPORTS.addDocument(data: data) { (error) in
            if let error = error {
                print("Error uploading report. \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
    }
    
    func uploadComment(postID: String, content: String, displayName: String, userID: String, handler: @escaping (_ success: Bool, _ commentID: String?) -> ()) {
        let document  = REF_POSTS.document(postID).collection(DatabasePostField.comments).document()
        let commentID = document.documentID
        
        let data: [String: Any] = [
            DatabaseCommentField.commentID: commentID,
            DatabaseCommentField.userID : userID,
            DatabaseCommentField.content : content,
            DatabaseCommentField.displayName : displayName,
            DatabaseCommentField.dateCreated : FieldValue.serverTimestamp()
        ]
        
        document.setData(data) { (error) in
            if let error = error {
                print("Error uploading comment \(error)")
                handler(false, nil)
                return
            } else {
                handler(true, commentID)
            }
        }
    }
    
    
    //MARK: GET FUNCTIONS
    
    func downloadPostForUser(userID: String, handler: @escaping(_ posts: [PostModel]) -> ()) {
        
        REF_POSTS.whereField(DatabasePostField.userID, isEqualTo: userID).getDocuments { (querySnapshot, error) in
            handler(self.getPostsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    func downloadPostsForFeed(handler: @escaping(_ posts: [PostModel]) -> ()) {
        REF_POSTS.order(by: DatabasePostField.dateCreated, descending: true).limit(to: 50).getDocuments { (querySnapshot, error) in
            handler(self.getPostsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    
    
    private func getPostsFromSnapshot(querySnapshot: QuerySnapshot?) -> [PostModel]{
        var postArray = [PostModel]()
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents {
                if
                    let userID = document.get(DatabasePostField.userID) as? String,
                    let displayName =  document.get(DatabasePostField.displayName) as? String,
                    let timeStamp = document.get(DatabasePostField.dateCreated) as? Timestamp {
                    
                    let caption = document.get(DatabasePostField.caption) as? String
                    let date = timeStamp.dateValue()
                    let postID = document.documentID
                    let likeCount = document.get(DatabasePostField.likeCount) as? Int ?? 0 //otherwise 0
                    var likedByUser: Bool = false
                    if let userIDArray = document.get(DatabasePostField.likedBy) as? [String], let userID = currentUserID {
                        likedByUser = userIDArray.contains(userID)
                    }
                    let newPost = PostModel(postID: postID, userID: userID, username: displayName, caption: caption, dateCreated: date, likeCount: likeCount, likedByUser: likedByUser)
                    
                    postArray.append(newPost)
                }
            }
            
            return postArray
            
        } else {
            print("No documents in snapshot found for this user")
            return postArray
        }
    }
    
    func downloadComments(postID: String, handler: @escaping(_ comments: [CommentModel]) -> ()) {
        REF_POSTS.document(postID).collection(DatabasePostField.comments).order(by: DatabaseCommentField.dateCreated, descending: false).getDocuments { (querySnapshot, error) in
            handler(self.getCommentFromSnapshot(querySnapshot: querySnapshot))
        }
        
    }
    
    
    private func getCommentFromSnapshot(querySnapshot: QuerySnapshot?) -> [CommentModel] {
        var commentArray = [CommentModel]()
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            for document in snapshot.documents {
                if let userID = document.get(DatabaseCommentField.userID) as? String,
                   let displayName = document.get(DatabaseCommentField.displayName) as? String,
                   let content = document.get(DatabaseCommentField.content) as? String,
                   let timestamp = document.get(DatabaseCommentField.dateCreated) as? Timestamp {
                    
                    let date = timestamp.dateValue()
                    let commentID = document.documentID
                
                    let newComment = CommentModel(commentID: commentID, userID: userID, username: displayName, content: content, dateCreated: date)
                    commentArray.append(newComment)
                }
            }
            return commentArray
        } else {
            print("No comments in document for this post")
            return commentArray
        }
    }
    //MARK: UPDATE FUNCTIONS
    
    func likePost(postID: String, currentUserID: String) {
        
        //Update the post count
        // Update the array of users who liked the post
        let increment: Int64 = 1
        let data: [String: Any] = [
            DatabasePostField.likeCount : FieldValue.increment(increment),
            DatabasePostField.likedBy: FieldValue.arrayUnion([currentUserID])
        ]
        
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    func unlikePost(postID: String, currentUserID: String) {
        
        //Update the post count
        // Update the array of users who liked the post
        let increment: Int64 = -1
        let data: [String: Any] = [
            DatabasePostField.likeCount : FieldValue.increment(increment),
            DatabasePostField.likedBy: FieldValue.arrayRemove([currentUserID])
        ]
        
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    func updateDisplayNameOnPost(userID: String, displayName: String) {
        downloadPostForUser(userID: userID) { (returnedPosts) in
            for post in returnedPosts {
                self.updatePostDisplayName(postID: post.postID, displayName: displayName)
            }
        }
    }
    
    private func updatePostDisplayName(postID: String, displayName: String) {
        let data: [String: Any] = [
            DatabasePostField.displayName : displayName
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
}
