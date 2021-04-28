import Foundation
import SwiftUI

struct CommentModel: Identifiable, Hashable {
    
    var id = UUID()
    var commentID: String // id for the comment in the database
    var userID: String // id for the user in the database
    var username: String// Username for the user in the Database
    var content: String// Actually comment text
    var dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
