//
//  DogGramApp.swift
//  DogGram
//
//  Created by Man Yuan on 04/06/2021.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct DogGramApp: App {
    
    init() {
        FirebaseApp.configure()
        
        // for google signin
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    GIDSignIn.sharedInstance().handle(url) // Google signin
                })
        }
    }
}
