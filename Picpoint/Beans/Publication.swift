//
//  Publication.swift
//  Picpoint
//
//  Created by alumnos on 5/3/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//
import Foundation
import UIKit

class Publication {
    
    var id: Int?
    var description:String?
    var image:UIImage?
    var imageName: String?
    var user_id:Int?
    var spot_id:Int?
    var tags:[Tag]?
    var userName:String?
    var userImage:UIImage?
    var spotName:String?
    
    init(id: Int, description: String, imageName: String, user_id: Int, tags:[Tag]) {
        self.id = id
        self.description = description
        self.imageName = imageName
        self.user_id = user_id
        self.tags = tags
    }
}
