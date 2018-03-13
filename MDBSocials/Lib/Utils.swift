//
//  Utils.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/2/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import Foundation
import PromiseKit
import Haneke
import CoreLocation

class Utils {
    static func getImage(withUrl: String) -> Promise<UIImage> {
        return Promise { fulfill, _ in
            let cache = Shared.imageCache
            if let imageUrl = URL(string: withUrl) {
                cache.fetch(URL: imageUrl as URL).onSuccess({ img in
                    fulfill(img)
                })
            }
        }
    }
}

