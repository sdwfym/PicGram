import SwiftUI

struct ImageGridView: View {
    
    @ObservedObject var posts: PostArrayObject
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
            spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/,
            pinnedViews: /*@START_MENU_TOKEN@*/[]/*@END_MENU_TOKEN@*/,
            content: {
                ForEach(posts.dataArray, id: \.self) { post in
                    NavigationLink(
                        destination: FeedView(posts: PostArrayObject(post: post), title: "Post"),
                        label: {
                            PostView(post: post, addheartAnimationToView: false, showHeaderOrFooter: false)
                        })
                }
                
        })
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView(posts: PostArrayObject(shuffled: true))
            .previewLayout(.sizeThatFits)
    }
}
