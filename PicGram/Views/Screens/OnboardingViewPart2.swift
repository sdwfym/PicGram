//
//  OnboardingViewPart2.swift
//  DogGram
//
//  Created by Man Yuan on 04/06/2021.
//

import SwiftUI

struct OnboardingViewPart2: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var displayName: String
    @Binding var email: String
    @Binding var providerId: String
    @Binding var provider: String
    
    
    @State var showImagePicker: Bool = false
    @State var imageSelected: UIImage = UIImage(named: "logo")!
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var showError = false
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20, content: {
            Text("What is your name")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.yellowColor)
            
            TextField("Add your name here...", text: $displayName)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.MyTheme.beigeColor)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
                .padding(.horizontal)
            
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                Text("Finish: Add profile picture")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
            })
            .accentColor(Color.MyTheme.purpleColor)
            .opacity(displayName != "" ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 1.0))
        })
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(Color.MyTheme.purpleColor)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .sheet(isPresented: $showImagePicker, onDismiss: createProfile, content: {
            ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
        })
        .alert(isPresented: $showError) {
            () -> Alert in
            return Alert(title: Text("Error creating profile 😤"))
        }
    }
    
    // MARK: FUNCTIONS
    func createProfile() {
        AuthService.instance.createNewUserInDatabase(name: displayName, email: email, providerID: providerId, provider: provider, profileImage: imageSelected) { (returnedUserID) in
            if let userID = returnedUserID {
                print("Successfully created new user in database")
                AuthService.instance.logInUserToApp(userID: userID) { (success) in
                    if success {
                        print("User logged in")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.presentationMode.wrappedValue.dismiss()
                        }

                        
                    } else {
                        print("Error logging in")
                        self.showError.toggle()
                    }
                }
                
            } else {
                print("error creating user in Database")
                self.showError.toggle()
            }
        }
        
    }
}

struct OnboardingViewPart2_Previews: PreviewProvider {
    @State static var testString: String = "test"

    static var previews: some View {
        OnboardingViewPart2(displayName: $testString, email: $testString, providerId: $testString, provider: $testString)
            .preferredColorScheme(.dark)
    }
}
