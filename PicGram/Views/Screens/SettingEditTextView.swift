//
//  SettingEditTextView.swift
//  DogGram
//
//  Created by Man Yuan on 04/06/2021.
//

import SwiftUI

struct SettingEditTextView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeholder: String
    @State var settingsEditTextOption: SettingsEditTextOption
    @State var showSuccessAlert: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Binding var profileText: String
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?

    
    var body: some View {
        VStack {
            
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
            TextField(placeholder, text: $submissionText)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .light ? Color.MyTheme.beigeColor : Color.MyTheme.purpleColor)
                .cornerRadius(20)
                .font(.headline)
                .autocapitalization(.sentences)
            
            Button(action: {
                if textIsApproprivate() {
                    saveText()
                }
            }, label: {
                Text("Save".uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            })
            .accentColor(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor)
            
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationBarTitle(title)
        .alert(isPresented: $showSuccessAlert){ () -> Alert in
            return Alert(title: Text("Saved! 🥳"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    
    //MARK: FUNCTIONS

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

    func saveText() {
        guard let userID = currentUserID else { return }
        switch settingsEditTextOption {
            case .displayName:
                
                //Update the UI on the Profile
                self.profileText = submissionText
                
                //Update the UserDefault
                UserDefaults.standard.setValue(submissionText, forKey: CurrentUserDefaults.displayName)
                
                //Update on all of the user's posts
                DataService.instance.updateDisplayNameOnPost(userID: userID, displayName: submissionText)
                
                //Update the user's profile in DB
                AuthService.instance.updateUserDisplayName(userID: userID, displayName: submissionText) { (success) in
                    if success {
                        self.showSuccessAlert.toggle()
                    }
                }
            case .bio:
                //Update the UI on the Profile
                self.profileText = submissionText
                
                //Update the UserDefault
                UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.bio)
                
                //Update the user's profile in DB
                AuthService.instance.updateUserBio(userID: userID, bio: submissionText) { (success) in
                    if success {
                        self.showSuccessAlert.toggle()
                    }
                }
        }
    }
}


struct SettingEditTextView_Previews: PreviewProvider {
    @State static var text: String = ""
    static var previews: some View {
        NavigationView {
            SettingEditTextView(title: "title", description: "description", placeholder: "placeholder", settingsEditTextOption: .displayName, profileText: $text)
        }
        .preferredColorScheme(.dark)
    }
}
