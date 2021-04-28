//
//  ProfileHeaderView.swift
//  DogGram
//
//  Created by Man Yuan on 04/06/2021.
//

import SwiftUI

struct ProfileHeaderView: View {
    @Binding var profileDisplayName: String
    @Binding var profileImage: UIImage
    @Binding var profileBio: String
    @ObservedObject var postArray: PostArrayObject



    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10, content: {
            
            // MARK: PROFILE PICTURE
            
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .cornerRadius(60)
            
            // MARK: USER NAME
            Text(profileDisplayName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // MARK: BIO
            if profileBio != "" {
                Text(profileBio)
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
            
            
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20, content: {
                
                // MARK: POSTS
                VStack(alignment: .center, spacing: 5, content: {
                    
                    Text(postArray.postCountString)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Posts")
                        .font(.callout)
                        .fontWeight(.medium)
                    
                })
                
                // MARK: LIKES
                VStack(alignment: .center, spacing: 5, content: {
                    
                    Text(postArray.likeCountString)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Likes")
                        .font(.callout)
                        .fontWeight(.medium)
                    
                })
            })
            
        })
        .frame(maxHeight: .infinity)
        .padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    @State static var name: String = "Joe"
    @State static var image: UIImage = UIImage(named: "pic1")!
    static var previews: some View {
        ProfileHeaderView(profileDisplayName: $name, profileImage: $image, profileBio: $name, postArray: PostArrayObject(shuffled: false))
            .previewLayout(.sizeThatFits)
    }
}
