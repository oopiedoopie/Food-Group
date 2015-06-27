//
//  RegisterViewController.swift
//  Food Group
//
//  Created by Eric Cauble on 4/30/15.
//  Copyright (c) 2015 Oopie Doopie. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UITableViewController, UITextFieldDelegate {
    
    let swipeRec = UISwipeGestureRecognizer()
 
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        self.nameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.passwordField.secureTextEntry = true
        swipeRec.addTarget(self, action: "swipeToPopView")
        self.view.addGestureRecognizer(swipeRec)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.nameField.becomeFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.nameField {
            self.emailField.becomeFirstResponder()
        } else if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.register()
        }
        return true
    }
    
    @IBAction func registerButtonPressed(sender: UIButton) {
        self.register()
    }
    
    func register() {
        let name = nameField.text
        let email = emailField.text
        let password = passwordField.text.lowercaseString
        
        if count(name) == 0 {
            ProgressHUD.showError("Name cannot be empty")
            return
        }
        if count(password) == 0 {
            ProgressHUD.showError("Password cannot be empty")
            return
        }
        if count(email) == 0 {
            ProgressHUD.showError("Email cannot be empty")
            return
        }
        
        ProgressHUD.show("Please wait...", interaction: false)
        
        var user = PFUser()
        user.username = email
        user.password = password
        user.email = email
        user[PF_USER_EMAILCOPY] = email
        user[PF_USER_FULLNAME] = name
        user[PF_USER_FULLNAME_LOWER] = name.lowercaseString
        
        
        user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            if error == nil {
                PushNotication.parsePushUserAssign()
                ProgressHUD.showSuccess("Succeeded.")
                self.performSegueWithIdentifier("showMainNavVC", sender: nil)
            } else {
                if let userInfo = error!.userInfo {
                    ProgressHUD.showError(userInfo["error"] as! String)
            }
            }
        }
    }
    
    //sets the status bar color to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    //pops current controller on swipe
    func swipeToPopView(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
