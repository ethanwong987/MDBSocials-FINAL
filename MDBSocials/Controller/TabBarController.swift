//
//  TabBarController.swift
//  MDBSocials
//
//  Created by Ethan Wong on 3/3/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.items?[1].title = "Events"
        tabBar.barTintColor = Constants.cellColor
    }
}
