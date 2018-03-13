//
//  FeedVC.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/20/18.
//  Copyright © 2018 Ethan Wong. All rights reserved./Users/ethanwong/MDBiOS/Training Projects/MDBSocials/MDBSocials/Controller/FeedVC.swift
//

import UIKit
import Firebase
import FirebaseAuth
import ChameleonFramework
import ObjectMapper
import SwiftyJSON

class FeedVC: UIViewController {
    var posts: [Post] = []
    var myPosts: [Post] = []
    var auth = Auth.auth()
    var postView: UICollectionView!
    var postsRef: DatabaseReference = Database.database().reference().child("Posts")
    var storage: StorageReference = Storage.storage().reference()
    var currentUser: Users?
    var currPost: Post!
    var postUser: Users?
    var numPosts: Int = 0
    var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseClient.getCurrentUser().then {user in
            self.currentUser = user
            } .then { _ in
                DispatchQueue.main.async {
                    self.setUpNavBar()
                    self.setUpCollectionView()
                    self.getPosts()
                    self.changePosts()
        
                }
        }
    }
    
    func sortDate() {
        self.posts.sort { (post1, post2) -> Bool in
            return post1.date! > post2.date!
        }
    }
    
    func sortTime() {
        self.posts.sort { (post1, post2) -> Bool in
            return post1.time! > post2.time!
        }
    }

    func getPosts() {
        let ref = Database.database().reference()
        
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            if var dict = snapshot.value as? [String: Any] {
                dict["id"] = snapshot.key
                let newPost = Post(JSON: dict)
                if self.posts.map({$0.id}).contains(where: {$0 == newPost?.id}) == false {
                    self.posts.insert(newPost!, at: 0)
                    self.numPosts = self.numPosts + 1
                    Utils.getImage(withUrl: (newPost?.imageUrl)!).then { img in
                        newPost?.image = img
                        } .then {_ in
                            DispatchQueue.main.async {
                                self.postView.reloadData()
                            }
                    }
                }
                
                self.sortDate()
            }
        })
    }
    
    func changePosts() {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childChanged, with: { (snapshot) in
            self.postView.reloadData()
        })
    }
    
    func setUpNavBar(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Event", style: .plain, target: self, action: #selector(toNewSocial))
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.feedBackGroundColor
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.feedBackGroundColor
        self.navigationController?.navigationBar.barTintColor = Constants.cellColor
        self.title = "My Feed"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
    }
    
    @objc func toNewSocial() {
        performSegue(withIdentifier: "toNewSocial", sender: self)
    }
    
    @objc func signOut() {
        print("\(currentUser!) has signed out.")
        UserAuth.logOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpCollectionView(){
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let cvLayout = UICollectionViewFlowLayout()
        postView = UICollectionView(frame: frame, collectionViewLayout: cvLayout)
        postView.delegate = self
        postView.dataSource = self
        postView.register(FeedViewCell.self, forCellWithReuseIdentifier: "post")
        postView.backgroundColor = Constants.feedBackGroundColor
        view.addSubview(postView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let detailVC = segue.destination as! DetailVC
            detailVC.currPost = currPost
            detailVC.currUser = currentUser!
        }
    }
    
}


extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numPosts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! FeedViewCell
        let currentPost = posts[indexPath.row]
        
        cell.setupEventText()
        cell.setUpNumInterested()
        cell.setupEventPoster()
        //cell.setupActivityIndidicator()
        cell.setupEventImage()
        cell.createDateText()
        cell.createTimeText()
        cell.postTitleName = currentPost.postTitle
        cell.posterTextName = currentPost.poster
        cell.numInterestedName = String(describing: currentPost.numInterested.count)
        cell.dateTextName = currentPost.date
        cell.timeTextName = currentPost.time
        cell.image = currentPost.image
        cell.currUser = currentUser
        cell.currPost = currentPost
        
        cell.layer.borderWidth = 1.0
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 10
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
        cell.awakeFromNib()
        return cell
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: postView.bounds.width - 20, height: postView.bounds.height * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: postView.bounds.height * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currPost = posts[indexPath.row]
        performSegue(withIdentifier: "toDetails", sender: self)
    }
}

