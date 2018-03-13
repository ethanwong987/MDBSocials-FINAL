//
//  UserAuth.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/20/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PromiseKit

class UserAuth {
    
    static func signIn(email: String, password: String) -> Promise<User> {
        return Promise { fulfill, reject in
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    reject(error!)
                } else {
                    fulfill(user!)
                }
            }
        }
    }
    
    static func logOut() {
        try! Auth.auth().signOut()
    }
}

