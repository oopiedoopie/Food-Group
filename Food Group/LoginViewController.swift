//
//  LoginViewController.swift
//  Food Group
//
//  Created by Eric Cauble on 4/30/15.
//  Copyright (c) 2015 Oopie Doopie. All rights reserved.
//

import UIKit
import Parse
 

class LoginViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.emailField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.login()
        }
        return true
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        self.login();
    }
    
    func login() {
        let email = emailField.text.lowercaseString
        let password = passwordField.text
        
        if count(email) == 0 {
         ProgressHUD.showError("Email field is empty.")
            return
        } else {
           ProgressHUD.showError("Password field is empty.")
        }
        
         ProgressHUD.show("Signing in...", interaction: true)
        
        PFUser.logInWithUsernameInBackground(email, password: password)
        println(PFUser.currentUser()?.username)
    }
}
