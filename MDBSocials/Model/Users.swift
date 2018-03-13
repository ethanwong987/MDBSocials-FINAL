//
//  User.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/20/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Users: Mappable {
    var name: String?
    var email: String?
    var password: String?
    var id: String?
    var username: String?
    var imageUrl: String?
    var image: UIImage?
    var eventIds: [String] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                              <- map["id"]
        name                            <- map["name"]
        username                        <- map["username"]
        password                        <- map["password"]
        email                           <- map["email"]
        imageUrl                        <- map["imageUrl"]
        eventIds                        <- map["eventIds"]
    }
}


