//
//  SignUpVC.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/20/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import ChameleonFramework
import LocationPicker
import CoreLocation

class NewSocialVC: UIViewController {
    var eventName: SkyFloatingLabelTextField!
    var posterName: SkyFloatingLabelTextField!
    var enterDesc: SkyFloatingLabelTextField!
    var datePickerText: SkyFloatingLabelTextField!
    var timePickerText: SkyFloatingLabelTextField!
    var signUpTitle: UIImageView!
    var borderBox: UILabel!
    var eventPic: UIImageView!
    var createPostButton: UIButton!
    var backToLogin: UIButton!
    var profileImage: UIButton!
    var selectFromLibraryButton: UIButton!
    var takePictureButton: UIButton!
    var mapButton: UIButton!
    var timePicker: UIDatePicker!
    var picker = UIImagePickerController()
    var datePicker: UIDatePicker!
    
    var selectedLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        createNameLabel()
        createDescLabel()
        createDatePicker()
        createTimePicker()
        createEventLabel()
        createButtons()
        setUpMapButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func createEventLabel() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        eventName = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.3, width: vfw - 60, height: 45))
        eventName.lineColor = Constants.feedBackGroundColor!
        eventName.selectedTitleColor = Constants.feedBackGroundColor!
        eventName.selectedLineColor = Constants.feedBackGroundColor!
        eventName.tintColor = Constants.feedBackGroundColor!
        eventName.placeholder = "Event Name"
        eventName.placeholderColor = Constants.feedBackGroundColor!
        view.addSubview(eventName)
    }
    
    func createNameLabel() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        posterName = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.4, width: vfw - 60, height: 45))
        posterName.lineColor = Constants.feedBackGroundColor!
        posterName.selectedTitleColor = Constants.feedBackGroundColor!
        posterName.selectedLineColor = Constants.feedBackGroundColor!
        posterName.tintColor = Constants.feedBackGroundColor!
        posterName.placeholder = "Post Creator"
        posterName.placeholderColor = Constants.feedBackGroundColor!
        view.addSubview(posterName)
    }
    
    func createDescLabel() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        enterDesc = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.5, width: vfw - 60, height: 45))
        enterDesc.lineColor = Constants.feedBackGroundColor!
        enterDesc.selectedTitleColor = Constants.feedBackGroundColor!
        enterDesc.selectedLineColor = Constants.feedBackGroundColor!
        enterDesc.tintColor = Constants.feedBackGroundColor!
        enterDesc.placeholder = "Description of Event"
        enterDesc.placeholderColor = Constants.feedBackGroundColor!
        view.addSubview(enterDesc)
    }
    
    func createDatePicker() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        datePickerText = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.6, width: vfw - 60, height: 45))
        datePickerText.lineColor = Constants.feedBackGroundColor!
        datePickerText.selectedTitleColor = Constants.feedBackGroundColor!
        datePickerText.selectedLineColor = Constants.feedBackGroundColor!
        datePickerText.tintColor = Constants.feedBackGroundColor!
        datePickerText.placeholder = "Date"
        datePickerText.placeholderColor = Constants.feedBackGroundColor!
        datePickerText.adjustsFontSizeToFitWidth = true
        datePickerText.textAlignment = .left
        datePickerText.layer.masksToBounds = true
        datePickerText.textColor = .black
        view.addSubview(datePickerText)
        setupDatePicker()
    }
    
    func createTimePicker(){
        let vfw = view.frame.width
        let vfh = view.frame.height
        timePickerText = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.7, width: vfw - 60, height: 45))
        timePickerText.lineColor = Constants.feedBackGroundColor!
        timePickerText.selectedTitleColor = Constants.feedBackGroundColor!
        timePickerText.selectedLineColor = Constants.feedBackGroundColor!
        timePickerText.tintColor = Constants.feedBackGroundColor!
        timePickerText.placeholder = "Time"
        timePickerText.placeholderColor = Constants.feedBackGroundColor!
        timePickerText.adjustsFontSizeToFitWidth = true
        timePickerText.textAlignment = .left
        timePickerText.layer.masksToBounds = true
        timePickerText.textColor = .black
        view.addSubview(timePickerText)
        setUpTimePicker()
    }
    
    func setUpTimePicker(){
        timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(getTime))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        timePickerText.inputAccessoryView = toolbar
        timePickerText.inputView = timePicker
    }
    
    @objc func getTime() {
        timePicker.datePickerMode = .time
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timePickerText.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    func setupDatePicker(){
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveText))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        datePickerText.inputAccessoryView = toolbar
        datePickerText.inputView = datePicker
    }
    
    @objc func saveText(){
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        datePickerText.text = selectedDate
        self.view.endEditing(true)
    }
    
    @objc func cancel(){
        self.view.endEditing(true)
    }
    
    func setUpUI() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        
        view.backgroundColor = Constants.cellColor
        borderBox = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.3, width: vfw-30, height: vfh * 0.65))
        borderBox.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        borderBox.layer.masksToBounds = true
        borderBox.layer.cornerRadius = 10
        
        eventPic = UIImageView(frame: CGRect(x: vfw*0.04, y: vfh*0.05, width: vfw-30, height: vfh*0.15))
        selectFromLibraryButton = UIButton(frame: eventPic.frame)
        selectFromLibraryButton.setTitle("SELECT \n AN IMAGE", for: .normal)
        selectFromLibraryButton.titleLabel?.numberOfLines = 0
        selectFromLibraryButton.setTitleColor(UIColor.blue, for: .normal)
        selectFromLibraryButton.layer.borderColor = Constants.feedBackGroundColor?.cgColor
        selectFromLibraryButton.layer.borderWidth = 3
        selectFromLibraryButton.setTitleColor(Constants.feedBackGroundColor, for: .normal)
        selectFromLibraryButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 50)
        selectFromLibraryButton.titleLabel?.textAlignment = .center
        selectFromLibraryButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        
        view.addSubview(borderBox)
        view.addSubview(eventPic)
        view.addSubview(selectFromLibraryButton)
        view.bringSubview(toFront: selectFromLibraryButton)
    }
    
    @objc func pickImage(sender: UIButton!) {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func createButtons() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        
        createPostButton = UIButton(frame: CGRect(x: vfw * 0.07, y: vfh * 0.81, width: vfw - 50, height: 40))
        createPostButton.setTitle("Create Post", for: .normal)
        createPostButton.backgroundColor = Constants.feedBackGroundColor!
        createPostButton.addTarget(self, action: #selector(createPostToFeed), for: .touchUpInside)
        createPostButton.layer.cornerRadius = 10
        
        backToLogin = UIButton(frame: CGRect(x: vfw * 0.07, y: vfh * 0.87, width: vfw - 50, height: 40))
        backToLogin.setTitle("Back To Feed", for: .normal)
        backToLogin.setTitleColor(.white, for: .normal)
        backToLogin.addTarget(self, action: #selector(backToFeed), for: .touchUpInside)
        
        
        takePictureButton = UIButton(frame: CGRect(x: vfw*0.15, y: vfh*0.22, width: vfw*0.3, height: vfh*0.05))
        takePictureButton.backgroundColor = Constants.feedBackGroundColor
        takePictureButton.setTitle("Take a photo", for: .normal)
        takePictureButton.layer.cornerRadius = 10
        takePictureButton.layer.borderColor = UIColor.white.cgColor
        takePictureButton.layer.borderWidth = 1
        takePictureButton.addTarget(self, action: #selector(selectPictureFromCamera), for: .touchUpInside)
        
        view.addSubview(takePictureButton)
        view.addSubview(backToLogin)
        view.addSubview(createPostButton)
    }
    
    func setUpMapButton() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        mapButton = UIButton(frame: CGRect(x: vfw*0.6, y: vfh*0.22, width: vfw*0.3, height: vfh*0.05))
        mapButton.backgroundColor = Constants.feedBackGroundColor
        mapButton.setTitle("Pick Location", for: .normal)
        mapButton.layer.cornerRadius = 10
        mapButton.layer.borderColor = UIColor.white.cgColor
        mapButton.layer.borderWidth = 1
        mapButton.addTarget(self, action: #selector(toMap), for: .touchUpInside)
        view.addSubview(mapButton)
    }
    
    @objc func toMap() {
        let locationPicker = LocationPickerViewController()
        
        locationPicker.showCurrentLocationButton = true
        locationPicker.currentLocationButtonBackground = Constants.MDBBlue!
        locationPicker.showCurrentLocationInitially = true
        locationPicker.mapType = .standard
        
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.resultRegionDistance = 100
        locationPicker.completion = { location in
            self.selectedLocation = location?.coordinate
        }
        
        
        self.present(locationPicker, animated: true) {
            print("Selecting location")
        }
    }
    
    @objc func selectPictureFromCamera() {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func createPostToFeed() {
        createPostButton.isEnabled = false
        if !areTextFieldsCompleted() && !isImageThere(){
            let alert = self.createAlert(warning: "Fill out all fields!")
            self.present(alert, animated: true, completion: nil)
        } else if !areTextFieldsCompleted() {
            let alert = self.createAlert(warning: "Fill out all text fields!")
            self.present(alert, animated: true, completion: nil)
        } else if !isImageThere() {
            let alert = self.createAlert(warning: "Select an image.")
            self.present(alert, animated: true, completion: nil)
        } else {
            self.createPostButton.isEnabled = false
            let postsRef = Database.database().reference().child("Posts")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let imageData = UIImageJPEGRepresentation(eventPic.image!, 0.7)
            postsRef.child("Users").child((Auth.auth().currentUser?.uid)!).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
                let date = self.datePickerText.text!
                let time = self.timePickerText.text!
                let posterId = Auth.auth().currentUser?.uid
                let postText = self.enterDesc.text!
                let poster = self.posterName.text!
                let numInterested = 0
                let postTitle = self.eventName.text!
                let location = self.selectedLocation!
                var newPost = ["postTitle": postTitle, "date": date, "time": time, "numInterested": numInterested, "text": postText, "poster": poster, "imageUrl": "", "posterId": posterId, "latitude":location.latitude, "longitude":location.longitude] as [String : Any]
                let key = postsRef.childByAutoId().key
                let storage = Storage.storage().reference().child("Posts").child(key)
                storage.putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                    if error == nil {
                        let imageUrl = metadata?.downloadURL()?.absoluteString
                        newPost["imageUrl"] = imageUrl
                        postsRef.updateChildValues(["\(key)": newPost])
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        let alert = self.createAlert(warning: error!.localizedDescription)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            })
        }
    }
    
    func areTextFieldsCompleted() -> Bool {
        return eventName.hasText && posterName.hasText && datePickerText.hasText && timePickerText.hasText && enterDesc.hasText
    }
    
    func isImageThere() -> Bool {
        return eventPic.image != nil
    }
    
    func createAlert(warning: String) -> UIAlertController {
        let alert = UIAlertController(title: "Warning:", message: warning, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    @objc func backToFeed() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NewSocialVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        selectFromLibraryButton.removeFromSuperview()
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        eventPic.contentMode = .scaleAspectFit
        eventPic.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

