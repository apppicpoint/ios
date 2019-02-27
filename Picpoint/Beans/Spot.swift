//
//  Spot.swift
//  Picpoint
//
//  Created by David on 01/02/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import Foundation
import UIKit

class Spot {
    var id: Int?
    var name:String?
    var desc: String?
    var longitude: Double?
    var latitude: Double?
    var distance: Float?
    var user_id: Int?
    var image: UIImage?
    var imageName: String?
    var tags: [Tag]?
    
    init() {
        
    }
    
    init(id: Int, name: String, desc: String?, longitude:Double, latitude:Double, user_id:Int, distance: Float?, imageName: String?, tags: [Tag]?) {
        self.id = id
        self.name = name
        self.desc = desc
        self.longitude = longitude
        self.latitude = latitude
        self.user_id = user_id
        self.distance = distance
        self.imageName = imageName
        self.tags = tags
        
    }
}
