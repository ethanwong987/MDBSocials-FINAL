//
//  ViewController.swift
//  MDBSocials
//
//  Created by Ethan Wong on 2/19/18.
//  Copyright © 2018 Ethan Wong. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import ChameleonFramework

class LoginVC: UIViewController {
    var emailText: SkyFloatingLabelTextField!
    var passWord: SkyFloatingLabelTextField!
    var userName: SkyFloatingLabelTextField!
    var welcomeTitle: UILabel!
    var borderBox: UILabel!
    var loginButton: UIButton!
    var signUpButton: UIButton!
    var MDBLogo: UIImageView!
    var MDBTitle: UILabel!
    var backgroundColours = [Constants.MDBBlue, Constants.cellColor, Constants.feedBackGroundColor]
    var backgroundLoop = 0
    
    override func viewDidLoad() {
        checkIfUserIsSignedIn()
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setUpLoginUI()
        animateBackgroundColour()
        createButtons()
        createTitle()
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
    
    private func checkIfUserIsSignedIn() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("\(user!) is signed in.")
                self.performSegue(withIdentifier: "toFeed", sender: self)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func animateBackgroundColour () {
        if backgroundLoop < backgroundColours.count - 1 {
            backgroundLoop += 1
        } else {
            backgroundLoop = 0
        }
        UIView.animate(withDuration: 5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.view.backgroundColor =  self.backgroundColours[self.backgroundLoop];
        }) {(Bool) -> Void in
            self.animateBackgroundColour();
        }
    }
    
    func setUpLoginUI() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        
        view.backgroundColor = Constants.MDBBlue
        borderBox = UILabel(frame: CGRect(x: vfw*0.04, y: vfh*0.58, width: vfw-30, height: 260))
        borderBox.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        borderBox.layer.masksToBounds = true
        borderBox.layer.cornerRadius = 10
        
        emailText = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.6, width: vfw - 60, height: 45))
        emailText.lineColor = Constants.MDBOrange!
        emailText.selectedTitleColor = Constants.MDBOrange!
        emailText.selectedLineColor = Constants.MDBOrange!
        emailText.tintColor = Constants.MDBOrange
        
        passWord = SkyFloatingLabelTextField(frame: CGRect(x: vfw * 0.07, y: vfh*0.7, width:
            vfw - 60, height: 45))
        passWord.lineColor = Constants.MDBOrange!
        passWord.selectedTitleColor = Constants.MDBOrange!
        passWord.selectedLineColor = Constants.MDBOrange!
        
        emailText.placeholder = "Email"
        emailText.placeholderColor = Constants.MDBOrange!
        passWord.placeholder = "Password"
        passWord.placeholderColor = Constants.MDBOrange!
        
        view.addSubview(borderBox)
        view.addSubview(emailText)
        view.addSubview(passWord)
    }
    
    func createButtons() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        loginButton = UIButton(frame: CGRect(x: vfw * 0.07, y: vfh * 0.81, width: vfw - 50, height: 40))
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = Constants.MDBOrange
        loginButton.addTarget(self, action: #selector(logInToFeed), for: .touchUpInside)
        loginButton.layer.cornerRadius = 10
        
        signUpButton = UIButton(frame: CGRect(x: vfw * 0.07, y: vfh * 0.88, width: vfw - 50, height: 40))
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = Constants.MDBBlue
        signUpButton.addTarget(self, action: #selector(toSignUp), for: .touchUpInside)
        signUpButton.layer.cornerRadius = 10
        
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
    }
    
    func createTitle() {
        let vfw = view.frame.width
        let vfh = view.frame.height
        
        MDBLogo = UIImageView(frame: CGRect(x:vfw * 0.06, y: -(vfh * 0.3), width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height))
        MDBLogo.image = UIImage(named: "mdb_white")
        MDBLogo.contentMode = .scaleAspectFit
        
        MDBTitle = UILabel(frame: CGRect(x: vfw*0.19, y: vfh*0.1, width: vfw-30, height: 300))
        MDBTitle.text = "SOCIALS"
        MDBTitle.textAlignment = .center
        MDBTitle.textColor = .white
        MDBTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 55)
        
        welcomeTitle = UILabel(frame: CGRect(x: vfw*0.07, y: vfh*0.5, width: vfw-30, height: 45))
        welcomeTitle.text = "WELCOME! PLEASE SIGN IN."
        welcomeTitle.font = UIFont(name: "HiraKakuProN-W3", size: 23)
        welcomeTitle.textColor = .white
        
        view.addSubview(welcomeTitle)
        view.addSubview(MDBTitle)
        view.addSubview(MDBLogo)
    }
    
    @objc func logInToFeed() {
        let email = emailText.text!
        let password = passWord.text!
        emailText.text = ""
        passWord.text = ""
        UserAuth.signIn(email: email, password: password).then { _ in
            self.performSegue(withIdentifier: "toFeed", sender: self)
        }
    }
    
    /*
     if error == nil {
     self.performSegue(withIdentifier: "toFeed", sender: self)}
     else {
     let alert = self.createAlert(warning: error!.localizedDescription)
     self.present(alert, animated: true, completion: nil)
     }
     
     }
     */
    
    
    func createAlert(warning: String) -> UIAlertController {
        let alert = UIAlertController(title: "Warning:", message: warning, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    
    @objc func toSignUp() {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
}

