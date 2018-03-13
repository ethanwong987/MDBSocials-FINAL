//
//  DetailVC.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/20/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import PromiseKit
import CoreGraphics
import CoreLocation
import MapKit
//make scrollview!
class DetailVC: UIViewController, UIScrollViewDelegate {
    var eventPic: UIImageView!
    var eventPosters: UILabel!
    var eventTitle: UILabel!
    var interestButton: UIButton!
    var interestLabel: UILabel!
    var borderBox: UILabel!
    var textBox: UILabel!
    var desc: UITextView!
    var viewTitle: UILabel!
    var isSelected = false
    var currPost: Post!
    var currUser: Users!
    var picker = UIImagePickerController()
    var whoInterestedButton: UIButton!
    
    var scrollView: UIScrollView!
    
    var modalView: AKModalView!
    var detailView: DetailView!
    var mapView: MKMapView!
    var delegate: NewSocialVC!
    
    var appleButton: UIButton!
    var lyftLabel: UILabel!
    var lyftText: String!
    
    var currentLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpEventPic()
        setUpEventTitle()
        setUpEventDescription()
        setUpInterestedButton()
        setUpMap()
        setUpAppleMapsButton()
        setUpWhoInterestedButton()
        setUpInterestCount()
        setUpLyftLabel()
        setUpScrollView()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.addPointer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.queryLyft()
        
        // Hide the navigation bar on the this view controller
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUpScrollView() {
        scrollView = UIScrollView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scrollView.delegate = self
        scrollView.addSubview(appleButton)
        scrollView.addSubview(viewTitle)
        scrollView.addSubview(borderBox)
        scrollView.addSubview(eventPic)
        scrollView.addSubview(eventTitle)
        scrollView.addSubview(textBox)
        scrollView.addSubview(desc)
        scrollView.addSubview(mapView)
        scrollView.addSubview(whoInterestedButton)
        scrollView.addSubview(interestButton)
        scrollView.addSubview(interestLabel)
        scrollView.addSubview(lyftLabel)

        scrollView.contentSize = CGSize(width: view.frame.width, height: mapView.frame.maxY)
        view.addSubview(scrollView)
    }
    
    func setUpUI(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        view.backgroundColor = Constants.cellColor
        self.navigationController?.navigationBar.tintColor = Constants.feedBackGroundColor
        
        viewTitle = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.07, width: vfw-30, height: vfh*0.1))
        viewTitle.text = currPost.date! + "  " + currPost.time!
        viewTitle.textColor = Constants.feedBackGroundColor
        viewTitle.font = UIFont(name:"AppleSDGothicNeo-Medium ", size: 24)
        
        borderBox = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.52, width: vfw-30, height: vfh*0.27))
        borderBox.backgroundColor = Constants.feedBackGroundColor?.withAlphaComponent(0.6)
        borderBox.layer.masksToBounds = true
        borderBox.layer.cornerRadius = 10
        borderBox.layer.borderWidth = 1
        borderBox.layer.borderColor = UIColor.white.cgColor
        view.addSubview(borderBox)
        view.addSubview(viewTitle)
    }
    
    func setUpEventPic(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        eventPic = UIImageView(frame: CGRect(x: vfw*0.04, y: vfh*0.15, width: vfw * 0.67, height: vfh*0.35))
        if currPost.image == nil {
            eventPic.image = UIImage(named:"default-image")
        } else {
            eventPic.image = currPost.image
        }
        eventPic.layer.borderWidth = 1
        eventPic.layer.masksToBounds = false
        eventPic.layer.borderColor = UIColor.white.cgColor
        eventPic.layer.cornerRadius = 10
        eventPic.clipsToBounds = true
        view.addSubview(eventPic)
    }
    
    func setUpEventTitle(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        eventTitle = UILabel(frame: CGRect(x: vfw*0.08, y: vfh * 0.52, width: vfw-50, height: vfh*0.1))
        eventTitle.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 24)
        eventTitle.text = currPost.postTitle
        eventTitle.textColor = .white
        view.addSubview(eventTitle)
    }
    
    func setUpEventDescription(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        textBox = UILabel(frame: CGRect(x: vfw*0.08, y: vfh*0.6, width: vfw-60, height: vfh*0.12))
        textBox.backgroundColor = UIColor.white
        textBox.layer.masksToBounds = true
        textBox.layer.cornerRadius = 10
        view.addSubview(textBox)
        
        desc = UITextView(frame: CGRect(x: vfw*0.12, y: vfh*0.6, width: vfw-90, height: vfw*0.18))
        desc.text = currPost.text
        desc.font = UIFont(name: "HelveticaNeue", size: 18)
        view.addSubview(desc)
    }
    
    func setUpMap() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        mapView = MKMapView(frame: CGRect(x: vfw*0.04, y: vfh*0.97, width: vfw-30, height: vfh*0.4))
        mapView.mapType = .standard
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        view.addSubview(mapView)
    }
    
    func setUpAppleMapsButton() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        appleButton = UIButton(frame: CGRect(x: vfw*0.04, y: vfh*0.8, width: vfw-30, height: vfh*0.06))
        appleButton.setTitle("Open in Apple Maps!", for: .normal)
        appleButton.backgroundColor = Constants.feedBackGroundColor
        appleButton.addTarget(self, action: #selector(openAppleMaps), for: .touchUpInside)
        appleButton.setTitleColor(.white, for: .normal)
        appleButton.layer.cornerRadius = 10
        appleButton.clipsToBounds = true
        appleButton.layer.borderColor = UIColor.white.cgColor
        appleButton.layer.borderWidth = 1
        view.addSubview(appleButton)
    }
    
    func addPointer(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: currPost.latitude!, longitude: currPost.longitude!)
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.002, 0.002)), animated: true)
    }
    
    @objc func openAppleMaps() {
        let coordinate = CLLocationCoordinate2DMake(37.786272279415272, -122.40631651595199)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Destination/Target Address or Name"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    func setUpLyftLabel() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        self.lyftLabel = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.87, width: vfw-30, height: vfh*0.07))
        self.lyftLabel.text = "Your car ride"
        self.lyftLabel.backgroundColor = Constants.lyftColor
        self.lyftLabel.text = lyftText
        self.lyftLabel.textColor = .white
        self.lyftLabel.layer.cornerRadius = 10
        self.lyftLabel.layer.borderWidth = 1
        self.lyftLabel.layer.borderColor = UIColor.white.cgColor
        self.lyftLabel.clipsToBounds = true
        self.view.addSubview(self.lyftLabel)
    }
    func queryLyft(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        let eventLocation = CLLocationCoordinate2DMake(currPost.latitude!, currPost.longitude!)
        if self.currentLocation != nil {
            LyftHelper.getRideEstimate(pickup: self.currentLocation!, dropoff: eventLocation) { costEstimate in
                self.lyftText = "A Lyft will cost $" + String(describing: costEstimate.estimate!.maxEstimate.amount) + " your location."
            }
        } else {
            print("Cant get current location")
        }
    }
    
    func setUpWhoInterestedButton() {
        let sfw = view.frame.width
        let sfh = view.frame.height
        whoInterestedButton = UIButton(frame: CGRect(x: sfw * 0.75, y: sfh * 0.15, width: sfw * 0.21, height: sfh * 0.35))
        whoInterestedButton.backgroundColor = Constants.feedBackGroundColor
        whoInterestedButton.layer.cornerRadius = 10
        whoInterestedButton.layer.borderColor = UIColor.white.cgColor
        whoInterestedButton.layer.borderWidth = 1
        whoInterestedButton.setImage(UIImage(named:"whiteperson"), for: .normal)
        whoInterestedButton.addTarget(self, action: #selector(whoInterestedView), for: .touchUpInside)
        view.addSubview(whoInterestedButton)
    }
    
    @objc func whoInterestedView() {
        let navBarHeight = navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        detailView = DetailView(frame: CGRect(x: 15, y: 70, width: view.frame.width - 30, height: view.frame.height - 100))
        detailView.currPost = currPost
        detailView.currUser = currUser
        detailView.delegate = self
        modalView = AKModalView(view: detailView)
        modalView.dismissAnimation = .FadeOut
        navigationController?.view.addSubview(modalView)
        modalView.show()
    }
    
    func setUpInterestCount() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        interestLabel = UILabel(frame: CGRect(x: vfw*0.82, y: vfh*0.15, width: vfw*0.1, height: vfh*0.16))
        interestLabel.textColor = .white
        interestLabel.text = String(describing: currPost.numInterested.count)
        interestLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 50)
        view.addSubview(interestLabel)
    }
    
    func setUpInterestedButton(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        interestButton = UIButton(frame: CGRect(x: vfw*0.08, y: vfh * 0.73, width: vfw-45, height: vfh*0.05))
        interestButton.setTitle("I'm Interested!", for: .normal)
        interestButton.setTitleColor(.white, for: .normal)
        interestButton.layer.cornerRadius = 10
        interestButton.clipsToBounds = true
        interestButton.layer.borderColor = UIColor.white.cgColor
        interestButton.layer.borderWidth = 1
        
        if currPost.posterId == currUser.id {
            interestButton.addTarget(self, action: #selector(createAlert), for: .touchUpInside)
        } else {
            if currPost.numInterested.contains(currUser.id!) {
                interestButton.backgroundColor = Constants.MDBBlue
            }
            interestButton.addTarget(self, action: #selector(userIsInterested), for: .touchUpInside)
            view.addSubview(interestButton)
        }
    }
    
    @objc func createAlert(_ sender: UIButton) {
        sender.backgroundColor = Constants.MDBBlue
    }
    
    @objc func userIsInterested(_ sender: UIButton) {
        if sender.backgroundColor == Constants.MDBBlue {
            sender.backgroundColor = .clear
            var index = 0
            for id in currPost.numInterested {
                if currUser.id == id {
                    currPost.numInterested.remove(at: index)
                    let postRef = Database.database().reference().child("Posts").child(currPost.id!)
                    postRef.updateChildValues(["numInterested" : currPost.numInterested])

                } else {
                    index += 1
                }
            }
            var index1 = 0
            for eventId in currUser.eventIds {
                if currPost.id == eventId {
                    currUser.eventIds.remove(at: index1)
                    let postRef = Database.database().reference().child("Users").child(currUser.id!)
                    postRef.updateChildValues(["eventIds" : currUser.eventIds])
                } else {
                    index1 += 1
                }
            }
        } else {
            sender.backgroundColor = Constants.MDBBlue
            currPost.numInterested.append(currUser.id!)
            currUser.eventIds.append(currPost.id!)
            let postRef = Database.database().reference().child("Posts").child(currPost.id!)
            let userRef =
                Database.database().reference().child("Users").child(currUser.id!)
            postRef.updateChildValues(["numInterested" : currPost.numInterested])
            userRef.updateChildValues(["eventIds" : currUser.eventIds])
        }
            
        interestLabel.text = String(describing: currPost.numInterested.count)

}
}

extension DetailVC: DetailViewDelegate {
    func dismissDetailView() {
        modalView.dismiss()
    }
}

extension DetailVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updated location")
        guard let currentLoc: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.currentLocation = currentLoc
    }
}

