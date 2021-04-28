//
//  CommentsView.swift
//  DogGram
//
//  Created by Man Yuan on 04/06/2021.
//

import SwiftUI

struct CommentsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var submissionText: String = ""
    @State var commentArray = [CommentModel]()
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    
    var post: PostModel
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    var body: some View {
        VStack {
            //Messages scrollview
            ScrollView{
                LazyVStack {
                    ForEach(commentArray, id: \.self) { comment in
                        MessageView(comment: comment)
                    }
                }
            }
            
            //Bottom HStack
            HStack {
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(20)
                
                TextField("Add a comment here ... ", text: $submissionText)
                Button (action: {
                    if textIsApproprivate() {
                        addComment()
                    }
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                })
                .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
            }
            .padding(.all, 6)
        }
        .padding(.horizontal)
        .navigationBarTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            getComments()
            getProfilePicture()
        })
    }
    
    // MARK: FUNCTIONS
    
    func getProfilePicture() {
        guard let userID = currentUserID else { return }
        
        ImageManager.instance.downloadProfileImage(userID: userID) { (returnedImage) in
            if let image = returnedImage {
                self.profilePicture = image
            }
        }
    }
    
    func getComments() {
        guard self.commentArray.isEmpty else { return }
        
        print("GET COMMENTS FROM DATABASE")
        
        if let caption = post.caption, caption.count > 1 {
            let captionComment = CommentModel(commentID: "", userID: post.userID, username: post.username, content: caption, dateCreated: post.dateCreated)
            self.commentArray.append(captionComment)
        }
        
        DataService.instance.downloadComments(postID: post.postID) { (returnedComments) in
            self.commentArray.append(contentsOf: returnedComments)
        }
    }
    
    func textIsApproprivate() -> Bool {
        //Check if the text has curses
        //Check if the text is long enough
        //Check if the text is blank
        //Check for inappropriate things
        
        let badWordArray: [String] = ["shit", "ass"]
        
        let words = submissionText.components(separatedBy: " ")
        
        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        //checking for minimum character count
        if submissionText.count < 3 {
            return false
        }
        
        return true
        
    }
    
    func addComment() {
        guard let userID = currentUserID, let displayName = currentUserDisplayName else { return }
        DataService.instance.uploadComment(postID: post.postID, content: submissionText, displayName: displayName, userID: userID) { (success, returnedCommentID) in
            if success, let commentID = returnedCommentID{
                let newComment = CommentModel(commentID: commentID, userID: userID, username: displayName, content: submissionText, dateCreated: Date())
                
                self.commentArray.append(newComment)
                self.submissionText = ""
                
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
}

struct CommentsView_Previews: PreviewProvider {
    static let post = PostModel(postID: "asdf", userID: "asdf", username: "asdf", dateCreated: Date(), likeCount: 0, likedByUser: false)
    static var previews: some View {
        NavigationView {
            CommentsView(post: post)
        }
        .preferredColorScheme(.dark)
    }
}
