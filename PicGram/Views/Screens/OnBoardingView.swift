//
//  OnBoardingView.swift
//  DogGram
//
//  Created by Man Yuan on 04/06/2021.
//

import SwiftUI
import FirebaseAuth

struct OnBoardingView: View {
    
    
    @State var displayName: String = ""
    @State var email: String = ""
    @State var providerId: String = ""
    @State var provider: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State var showOnboardingPart2: Bool = false
    @State var showError: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .shadow(radius: 12)
            
            Text("Welcome to PicGram!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.purpleColor)
            
            Text("Sign up to see photos from your friends.")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.MyTheme.purpleColor)
                .padding()
            
            
            Button(action: {
                showOnboardingPart2.toggle()
            }, label: {
                SignInWithAppleButtonCustom()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
            })
            
            
            //MARK: SIGN IN WITH GOOGLE
            Button(action: {
                SignInWithGoogle.instance.startSignInWithGoogleFlow(view: self)
            }, label: {
                HStack {
                    Image(systemName: "globe")
                    
                    Text("Sign in with Google")
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color(.sRGB, red: 222/255, green: 82/255, blue: 70/255, opacity: 1.0))
                
                .cornerRadius(6)
                .font(.system(size: 24, weight: .medium, design: .default))
            })
            .accentColor(Color.white)
            
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Continue as guest".uppercased())
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding()
                
            })
            .accentColor(.black)
            
        }
        .padding(.all, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.MyTheme.beigeColor)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .fullScreenCover(isPresented: $showOnboardingPart2, onDismiss: {
            self.presentationMode.wrappedValue.dismiss()
        }, content: {
            OnboardingViewPart2(displayName: $displayName, email: $email, providerId: $providerId, provider: $provider)
        })
        .alert(isPresented: $showError, content: {
            return Alert(title: Text("Error signing in 😭"))
        })
    }
    
    
    //MARK: FUNCTIONS
    
    func connectToFirebase(name: String, email: String, provider: String, credential: AuthCredential) {
        
        AuthService.instance.logInUserToFirebase(credential: credential) { (returnProviderID, isError, isNewUser, returnedUserID) in
            if let newUser = isNewUser {
                if newUser {
                    //New user
                    if let providerID = returnProviderID, !isError {
                        //New user, continue to the onboarding part2
                        self.displayName = name
                        self.email = email
                        self.providerId = providerID
                        self.provider = provider
                        self.showOnboardingPart2.toggle()
                    } else {
                        print("Error getting providerID form log in user to Firebase")
                        self.showError.toggle()
                    }

                } else {
                    // Existing user
                    if let userID = returnedUserID {
                        //SUCCESS, LOG IN TO APP
                        AuthService.instance.logInUserToApp(userID: userID) { (success) in
                            if success {
                                print("Successful log in existing user")
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                print("Error logging existing user into out app")
                                self.showError.toggle()
                            }
                        }
                    } else {
                        print("Error getting USER ID form existing user to Firebase")
                        self.showError.toggle()
                    }
                }
            } else {
                print("Error getting into form log in user to Firebase")
                self.showError.toggle()
            }
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
