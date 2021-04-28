import Foundation

class PostArrayObject: ObservableObject {
    
    @Published var dataArray = [PostModel]()
    @Published var postCountString = "0"
    @Published var likeCountString = "0"
    
    ///USED FOR SINGLE POST ELECTION
    init(post: PostModel) {
        self.dataArray.append(post)
    }
    
    ///USED FOR GETTING POSTS FOR USER PROFILE
    init(userID: String) {
        print("GET POSTS FOR USER ID \(userID)")
        DataService.instance.downloadPostForUser(userID: userID) { (returnedPosts) in
            let sortedPosts = returnedPosts.sorted { (post1, post2) -> Bool in
                return post1.dateCreated > post2.dateCreated
            }
            self.dataArray.append(contentsOf: sortedPosts)
            self.updateCounts()
        }
    }
    
    ///USED FOR FEED
    init(shuffled: Bool) {
        
        print("GET POSTS FOR FEED. SHUFFLED: \(shuffled)")
        DataService.instance.downloadPostsForFeed { (returnedPosts) in
            if shuffled {
                let shuffledPosts = returnedPosts.shuffled()
                self.dataArray.append(contentsOf: shuffledPosts)
            } else {
                self.dataArray.append(contentsOf: returnedPosts)
            }
        }
    }
    
    
    func updateCounts() {
        self.postCountString = "\(self.dataArray.count)"
        
        let likeCountArray = dataArray.map { (existingPost) -> Int in
            return existingPost.likeCount
        }
        
        let sumOfLikeCountArray = likeCountArray.reduce(0, +)
        self.likeCountString = "\(sumOfLikeCountArray)"
    }
}
