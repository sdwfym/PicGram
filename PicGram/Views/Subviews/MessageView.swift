import SwiftUI

struct MessageView: View {
    
    @State var comment: CommentModel
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    
    var body: some View {
        HStack {
            
            // MARK: PROFILE IMAGE
            NavigationLink(
                destination: lazyView(content: {
                    ProfileView(isMyProfile: false, profileDisplayName: comment.username, profileUserID: comment.userID, posts: PostArrayObject(userID: comment.userID))
                }),
                label: {
                    Image(uiImage: profilePicture)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(20)
                })
           
            
            VStack(alignment: .leading, spacing: 4, content: {
                // MARK: USER NAME
                Text(comment.username)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // MARK: CONTENT
                Text(comment.content)
                    .padding(.all, 10)
                    .foregroundColor(.primary)
                    .background(Color.gray)
                    .cornerRadius(10)
            })
            
            Spacer(minLength: 0)
            
        }
        .onAppear {
            getProfileImage()
        }
    }
    
    
    //MARK: FUNCTIONS
    
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: comment.userID) { (returnImage) in
            if let image = returnImage {
                self.profilePicture = image
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    
    static var comment: CommentModel = CommentModel(commentID: "", userID: "", username: "Joe Green", content: "This photo is really cool. haha", dateCreated: Date())
    
    static var previews: some View {
        MessageView(comment: comment)
            .previewLayout(.sizeThatFits)
    }
}
