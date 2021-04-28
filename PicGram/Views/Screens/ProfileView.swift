import SwiftUI

struct ProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    var isMyProfile: Bool
    @State var profileDisplayName: String
    @State var profileBio: String = ""
    @State var showSettings: Bool = false
    var profileUserID: String
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    
    var posts: PostArrayObject
    
    var body: some View {
        ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content: {
            ProfileHeaderView(profileDisplayName: $profileDisplayName, profileImage: $profileImage, profileBio: $profileBio, postArray: posts)
            Divider()
            ImageGridView(posts: posts)
        })
        .navigationBarTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    showSettings.toggle()
                                }, label: {
                                    Image(systemName: "line.horizontal.3")
                                })
                                .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                                .opacity(isMyProfile ? 1.0 : 0.0)
        )
        .onAppear(perform: {
            getProfileImage()
            getAdditinalProfileInfo()
            
        })
        .sheet(isPresented: $showSettings, content: {
            SettingsView(userDisplayName: $profileDisplayName, userBio: $profileBio, userProfilePicture: $profileImage)
                .preferredColorScheme(colorScheme)
        })
    }
    
    //MARK: FUNCTIONS
    
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: profileUserID) { (returnedImage) in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
    
    func getAdditinalProfileInfo() {
        AuthService.instance.getUserInfo(forUserID: profileUserID) { (returnedDisplayName, returnedBio) in
            if let displayName = returnedDisplayName {
                self.profileDisplayName = displayName
            }
            if let bio = returnedBio {
                self.profileBio = bio
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            ProfileView(isMyProfile: false, profileDisplayName: "Joe", profileUserID: "", posts: PostArrayObject(userID: ""))
        }
    }
}
