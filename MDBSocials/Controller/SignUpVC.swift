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

class SignUpVC: UIViewController {
    var fullname: SkyFloatingLabelTextField!
    var userName: SkyFloatingLabelTextField!
    var passWord: SkyFloatingLabelTextField!
    var confirmPwd: SkyFloatingLabelTextField!
    var emailText: SkyFloatingLabelTextField!
    var profilePicButton: UIButton!
    var borderBox: UILabel!
    var signUpButton: UIButton!
    var backToLogin: UIButton!
    var profileImage: UIButton!
    var picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        createNameLabels()
        createPassWordLabel()
        createUserLabel()
        createEmailLabel()
        createButtons()
    }
    
    func createNameLabels() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        fullname = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.4, width: vfw - 60, height: 45))
        fullname.lineColor = Constants.feedBackGroundColor!
        fullname.selectedTitleColor = Constants.feedBackGroundColor!
        fullname.selectedLineColor = Constants.feedBackGroundColor!
        fullname.tintColor = Constants.feedBackGroundColor
        fullname.placeholder = "Full Name"
        fullname.placeholderColor = Constants.feedBackGroundColor!
        view.addSubview(fullname)
    }
    
    func createUserLabel() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        userName = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.5, width: vfw - 60, height: 45))
        userName.lineColor = Constants.feedBackGroundColor!
        userName.selectedTitleColor = Constants.feedBackGroundColor!
        userName.selectedLineColor = Constants.feedBackGroundColor!
        userName.tintColor = Constants.feedBackGroundColor
        userName.placeholder = "Username"
        userName.placeholderColor = Constants.feedBackGroundColor!
        view.addSubview(userName)
    }
    
    func createPassWordLabel() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        passWord = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.7, width:
            vfw - 60, height: 45))
        passWord.lineColor = Constants.feedBackGroundColor!
        passWord.selectedTitleColor = Constants.feedBackGroundColor!
        passWord.selectedLineColor = Constants.feedBackGroundColor!
        passWord.placeholder = "Password"
        passWord.placeholderColor = Constants.feedBackGroundColor!
        view.addSubview(passWord)
    }
    
    func createEmailLabel() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        emailText = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.6, width: vfw - 60, height: 45))
        emailText.lineColor = Constants.feedBackGroundColor!
        emailText.selectedTitleColor = Constants.feedBackGroundColor!
        emailText.selectedLineColor = Constants.feedBackGroundColor!
        emailText.tintColor = Constants.feedBackGroundColor
        emailText.placeholder = "Email"
        emailText.placeholderColor = Constants.feedBackGroundColor!
        view.addSubview(emailText)
    }
    
    func setUpUI() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        
        view.backgroundColor = Constants.cellColor
        borderBox = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.38, width: vfw-30, height: vfh * 0.55))
        borderBox.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        borderBox.layer.masksToBounds = true
        borderBox.layer.cornerRadius = 10
        
        profilePicButton = UIButton(frame: CGRect(x: vfw*0.23, y: vfh*0.05, width: vfh * 0.3, height: vfh * 0.3))
        profilePicButton.setTitle("PROFILE \n PICTURE", for: .normal)
        profilePicButton.titleLabel?.numberOfLines = 0
        profilePicButton.titleLabel?.textColor = .white
        profilePicButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 30)
        profilePicButton.titleLabel?.textAlignment = .center
        profilePicButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        profilePicButton.layer.borderColor = UIColor.white.cgColor
        profilePicButton.layer.borderWidth = 3
        profilePicButton.layer.cornerRadius = profilePicButton.frame.size.width / 2;
        profilePicButton.clipsToBounds = true
        
        view.addSubview(profilePicButton)
        view.addSubview(borderBox)
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
        
        signUpButton = UIButton(frame: CGRect(x: vfw * 0.07, y: vfh * 0.81, width: vfw - 50, height: 40))
        signUpButton.setTitle("Create Account", for: .normal)
        signUpButton.backgroundColor = Constants.feedBackGroundColor
        signUpButton.addTarget(self, action: #selector(signUpToFeed), for: .touchUpInside)
        signUpButton.layer.cornerRadius = 10
        
        backToLogin = UIButton(frame: CGRect(x: vfw * 0.07, y: vfh * 0.87, width: vfw - 50, height: 40))
        backToLogin.setTitle("Back To Login", for: .normal)
        backToLogin.setTitleColor(.white, for: .normal)
        backToLogin.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
        
        view.addSubview(backToLogin)
        view.addSubview(signUpButton)
    }
    
    @objc func signUpToFeed() {
        let email = emailText.text!
        let password = passWord.text!
        let name = fullname.text!
        let username = userName.text!
        
        Auth.auth().createUser(withEmail: email, password: password, completion:{ (user, error) in if error == nil {
            let ref = Database.database().reference()
            let uid = (user?.uid)!
            let userRef = ref.child("Users").child(uid)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let imageData = UIImageJPEGRepresentation(self.profilePicButton.currentImage!, 0.7)
            userRef.setValue(["uid":uid, "name":name, "email":email, "username":username, "password":password, "imageUrl": "", "eventIds": []])
            let key = userRef.childByAutoId().key
            let storage = Storage.storage().reference().child("Users").child(key)
            storage.putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                if error == nil {
                    let imageUrl = metadata?.downloadURL()?.absoluteString
                    userRef.updateChildValues(["imageUrl": imageUrl])
                    self.performSegue(withIdentifier: "signUpToFeed", sender: self)
                    } else {
                    
                        let alert = self.createAlert(warning: error!.localizedDescription)
                        self.present(alert, animated: true, completion: nil)
                    }
            })
            if let error = error {
                print(error.localizedDescription)
            }
            }
        })
    }
    
    func createAlert(warning: String) -> UIAlertController {
        let alert = UIAlertController(title: "Warning:", message: warning, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    @objc func toLogin() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePicButton.contentMode = .scaleAspectFit
        profilePicButton.setImage(chosenImage, for: .normal)
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

