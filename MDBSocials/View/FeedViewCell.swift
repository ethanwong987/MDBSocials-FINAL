//
//  FeedViewCell.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/20/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

//
//  PostCollectionViewCell.swift
//  MDBSocials
//
//  Created by Ethan Wong on 9/22/17.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit
import SwiftyJSON

class FeedViewCell: UICollectionViewCell {
    
    var eventImg: UIImageView!
    var image: UIImage!
    var posterText: UILabel!
    var posterTextName: String!
    var descText: UILabel!
    var descTextName: String!
    var dateText: UILabel!
    var dateTextName: String!
    var timeText: UILabel!
    var timeTextName: String!
    var postTitle: UILabel!
    var postTitleName: String!
    var numInterested: UILabel!
    var numInterestedName: String!
    var whoInterestedButton: UIButton!
    var borderBox: UILabel!
    var profileImageView: UIImageView!
    var profImage: UIImage!
    var activityIndicator: UIActivityIndicatorView!
    var currPost: Post!
    var currUser: Users!
    var postUser: Users!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        self.backgroundColor = Constants.cellColor
        setUpUI()
        setUpProfileImage()
        //setupActivityIndidicator()
        setupEventText()
        setUpWhoInterested()
        setUpNumInterested()
        setupEventPoster()
        setupEventImage()
        createDateText()
        createTimeText()
    }
    
//    func setupActivityIndidicator(){
//        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 50, y: self.frame.height/2 - 20, width: 40, height: 40))
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.backgroundColor = (UIColor (white: 0.3, alpha: 0.8))
//        activityIndicator.layer.cornerRadius = 5
//        addSubview(activityIndicator)
//    }
//    func startLoadingView() {
//        activityIndicator.startAnimating()
//    }
//
//    func stopLoadingView() {
//        activityIndicator.stopAnimating()
//    }
    
    func setUpUI() {
        let sfw = self.frame.width
        let sfh = self.frame.height
        borderBox = UILabel(frame: CGRect(x: 0, y: 0, width: sfw, height: sfh*0.18))
        borderBox.backgroundColor = UIColor.white.withAlphaComponent(1)
        borderBox.layer.masksToBounds = true
        borderBox.clipsToBounds = true
        borderBox.layer.cornerRadius = 10
        borderBox.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        addSubview(borderBox)
    }
    
    func setUpProfileImage() {
        let sfw = self.frame.width
        let sfh = self.frame.height
        profileImageView = UIImageView(frame: CGRect(x: sfw * 0.02, y: sfh * 0.02, width: sfh * 0.15, height: sfh*0.15))
        firstly {
            return FirebaseClient.fetchUser(id: currPost.posterId!)
            }.then { user -> Void in
                //print("user is")
                //print(user.toJSON())
                self.postUser = user
                //print(self.postUser.toJSON())
            } .then { _ in
                DispatchQueue.main.async {
                    Utils.getImage(withUrl: self.postUser.imageUrl!).then { img in
                        self.profileImageView.image = img
                    }
                }
        }
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = Constants.cellColor?.cgColor
        profileImageView.layer.borderWidth = 1
        profileImageView.contentMode = .scaleAspectFill
        addSubview(profileImageView)
    }
    
    func setUpWhoInterested() {
        let sfw = self.frame.width
        let sfh = self.frame.height
        whoInterestedButton = UIButton(frame: CGRect(x: sfw * 0.9, y: sfh * 0.9, width: sfw * 0.07, height: sfh * 0.08))
        whoInterestedButton.setBackgroundImage(UIImage(named:"person"), for: .normal)
        addSubview(whoInterestedButton)
    }
    
    func setupEventImage() {
        let sfw = self.frame.width
        let sfh = self.frame.height
        eventImg = UIImageView(frame: CGRect(x: sfw * 0.05, y: sfh * 0.225, width: sfw * 0.9, height: sfh * 0.55))
        eventImg.image = image
        eventImg.clipsToBounds = true
        eventImg.layer.borderWidth = 1
        eventImg.layer.borderColor = UIColor.white.cgColor
        eventImg.layer.cornerRadius = 10
        eventImg.contentMode = .scaleAspectFill
        addSubview(eventImg)
    }
    
    func setUpText(label: UILabel) {
        label.font = UIFont(name: "SFUIText-Medium", size: 17)
        label.textColor = .white
        label.adjustsFontForContentSizeCategory = true
    }
    
    func setUpNumInterested() {
        let sfw = self.frame.width
        let sfh = self.frame.height
        
        numInterested = UILabel(frame: CGRect(x: sfw * 0.85, y: sfh * 0.89, width: sfw, height: sfh * 0.1))
        numInterested.font = UIFont(name: "SFUIText-Medium", size: 20)
        numInterested.textColor = Constants.feedBackGroundColor
        numInterested.adjustsFontForContentSizeCategory = true
        numInterested.text = numInterestedName
        
        addSubview(numInterested)
    }
    
    func createDateText(){
        let sfw = self.frame.width
        let sfh = self.frame.height
        
        dateText = UILabel(frame: CGRect(x: sfw * 0.02, y: sfh * 0.89, width: sfw, height: sfh * 0.1))
        setUpText(label: dateText)
        dateText.text = dateTextName
        
        addSubview(dateText)
        
    }
    func createTimeText() {
        let sfw = self.frame.width
        let sfh = self.frame.height
        
        timeText = UILabel(frame: CGRect(x: 0, y: sfh * 0.89, width: sfw, height: sfh * 0.1))
        setUpText(label: timeText)
        timeText.text = timeTextName
        timeText.textAlignment = .center
        
        addSubview(timeText)
    }
    
    func setupEventText() {
        let sfw = self.frame.width
        let sfh = self.frame.height
        postTitle = UILabel(frame: CGRect(x: sfw * 0.02, y: sfh * 0.7, width: sfw, height: sfh * 0.3))
        postTitle.textColor = Constants.feedBackGroundColor
        postTitle.font = UIFont(name: "SFUIText-Medium", size: 30)
        postTitle.adjustsFontForContentSizeCategory = true
        postTitle.text = postTitleName
        addSubview(postTitle)
    }
    
    func setupEventPoster() {
        let sfw = self.frame.width
        let sfh = self.frame.height
        posterText = UILabel(frame: CGRect(x: sfw * 0.2, y: sfh * 0.02, width: sfw, height: sfh * 0.15))
        posterText.font = UIFont(name: "SFUIText-Medium", size: 20)
        posterText.textColor = Constants.cellColor
        posterText.text = posterTextName
        addSubview(posterText)
    }
    
}

