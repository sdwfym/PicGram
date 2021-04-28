import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var showSignoutError: Bool = false
    
    @Binding var userDisplayName: String
    @Binding var userBio: String
    
    @Binding var userProfilePicture: UIImage
    
    var body: some View {
        NavigationView {
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false, content: {
                
                // MARK: SECTION 1: DOGGRAM
                GroupBox(label: SettingsLabelView(labelText: "PicGram", labelImage: "dot.radiowaves.left.and.right"), content: {
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10, content: {
                        
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .cornerRadius(12)
                        
                        Text("PicGram is the #1 for posting pictures and sharing them across the world!")
                            .font(.footnote)
                    })
                })
                .padding()
                
                // MARK: SECTION 2: PROFILE
                GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill"), content: {
                    NavigationLink(
                        destination: SettingEditTextView(submissionText: userDisplayName, title: "Display name", description: "Your can edit your display name here, this will be seen by other users on your profile and on your posts!", placeholder: "Your display name here ...", settingsEditTextOption: .displayName, profileText: $userDisplayName),
                        label: {
                            SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.MyTheme.purpleColor)
                        })
                    
                    NavigationLink (
                        destination: SettingEditTextView(submissionText: userBio, title: "Profile Bio", description: "Your bio is a great place ti let users know a little about you. It will be shonw on your profile only", placeholder: "Your bio here ...", settingsEditTextOption: .bio, profileText: $userBio),
                        label: {
                            SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.purpleColor)
                        })
                    
                   
                    NavigationLink (
                        destination: SettingsEditImageView(title: "Profile Picture", description: "Your profile picture will be shown on your profile and on your posts!", selectedImage: userProfilePicture, profileImage: $userProfilePicture),
                        label: {
                            SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: Color.MyTheme.purpleColor)
                        })
                
                    Button(action: {
                        signOut()
                    }, label: {
                        SettingsRowView(leftIcon: "figure.walk", text: "Sign out", color: Color.MyTheme.purpleColor)
                    })
                    .alert(isPresented: $showSignoutError, content: {
                        return Alert(title: Text("Error signing out 🥵"))
                    })
                })
                .padding()
                
                // MARK: SECTION 3: APPLICATION
                GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone"), content: {
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.google.com")
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.MyTheme.yellowColor)
                    })
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.yahoo.com")
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Terms and Conditions", color: Color.MyTheme.yellowColor)
                    })
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.bing.com")
                    }, label: {
                        SettingsRowView(leftIcon: "globe", text: "PicGram's Website", color: Color.MyTheme.yellowColor)
                    })
 
                })
                .padding()
                
                // MARK: SECTION 4: APPLICATION
                
                GroupBox{
                    Text("PicGram was made with love. \n All Rights Reserved \n Cool Apps Inc. \n Copyright 2020 ❤️")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }
                .padding()
                .padding(.bottom, 80)
            })
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "xmark")
                                        font(.title)
                                    })
                                    .accentColor(.primary)
            
            )
        }
        .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
    }
    
    // MARK: FUNCTIONS
    
    func openCustomURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func signOut() {
        AuthService.instance.logOutUser { (success) in
            if(success) {
                print("Success fully logged out")
                
                //Dismiss setting view
                self.presentationMode.wrappedValue.dismiss()

            } else {
                print("Error logging out")
                self.showSignoutError.toggle()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var testString: String = "test string"
    @State static var image : UIImage = UIImage(named: "pic1")!
    static var previews: some View {
        SettingsView(userDisplayName: $testString, userBio: $testString, userProfilePicture: $image)
            .preferredColorScheme(.dark)
    }
}
