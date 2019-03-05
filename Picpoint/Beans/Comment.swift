

import UIKit

class Comment: Decodable {
    var id: Int
    var text: String?
    var user_id: Int?
    var comment_id: Int?
    var spot_id: Int?
    
    init(id: Int, text: String, user_id: Int, comment_id: Int?, spot_id: Int) {
        self.id = id
        self.text = text
        self.user_id = user_id
        self.comment_id = comment_id
        self.spot_id = spot_id
    }
    
}
