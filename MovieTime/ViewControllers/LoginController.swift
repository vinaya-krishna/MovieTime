//
//  ViewController.swift
//  MovieTime
//
//  Created by MovieTime on 07/12/18.
//  Copyright © 2018 sdsuios. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD


class LoginController: UIViewController {

    @IBOutlet weak var optionSelector: UISegmentedControl!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var nameText: UITextField!
    
    var userData:[String:String]!
    var ref: DatabaseReference!
    var isSignIn = true

    @IBAction func optionChanged(_ sender: UISegmentedControl) {
        isSignIn = !isSignIn
        
        if isSignIn{
            self.nameText.isHidden = true
            signinButton.setTitle("Log In", for: .normal)
        }
        else{
            self.nameText.isHidden = false
            signinButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func signinTap(_ sender: UIButton) {
        self.view.endEditing(true)
        if let email = emailText.text, let password = passwordText.text{
            if isSignIn{
                SVProgressHUD.show()
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    SVProgressHUD.dismiss()
        
                    if user != nil{
                        DispatchQueue.main.async {
                            self.view.makeToast("Loged In Successfully")
                            self.performSegue(withIdentifier: "goHome", sender: self)
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.view.makeToast(error!.localizedDescription)
                        }
                        
                        
                        return
                    }
                }
            }
            else{
                if let name = nameText.text{
                    
                    if name != ""{
                        self.userData = [
                            "name":name,
                            "email":email
                        ]
                        
                        SVProgressHUD.show()
                        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                            SVProgressHUD.dismiss()
                            guard let user = authResult?.user else {
                                DispatchQueue.main.async {
                                    self.view.makeToast(error!.localizedDescription)
                                }
                                return
                                
                            }
                            self.ref = Database.database().reference()
                            self.ref.child("users").child(user.uid).setValue(self.userData)
                             DispatchQueue.main.async {
                                self.view.makeToast("Registred Successfully")
                            }
                            
                            self.performSegue(withIdentifier: "goHome", sender: self)
                        }
                    }
                    else{
                        self.view.makeToast("Enter Name and Try Again!")
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
    }
}

