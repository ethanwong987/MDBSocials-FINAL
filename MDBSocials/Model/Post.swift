//
//  Post.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/20/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ObjectMapper


class Post: Mappable {
    var text: String?
    var imageUrl: String?
    var posterId: String?
    var poster: String?
    var numInterested: [String] = []
    var id: String?
    var image: UIImage?
    var date: String?
    var time: String?
    var postTitle: String?
    var latitude: Double?
    var longitude: Double?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id                              <- map["id"]
        postTitle                       <- map["postTitle"]
        numInterested                   <- map["numInterested"]
        text                            <- map["text"]
        imageUrl                        <- map["imageUrl"]
        date                            <- map["date"]
        time                            <- map["time"]
        posterId                        <- map["posterId"]
        poster                          <- map["poster"]
        latitude                        <- map["latitude"]
        longitude                       <- map["longitude"]
        
    }
}

