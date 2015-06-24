//
//  PasswordResetViewController.swift
//  Food Group
//
//  Created by Eric Cauble on 6/7/15.
//  Copyright (c) 2015 Oopie Doopie. All rights reserved.
//

import Foundation
import Parse
import Bolts
class PasswordResetViewController: UIViewController{
    
    let swipeRec = UISwipeGestureRecognizer()

    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRec.addTarget(self, action: "swipedView")
        self.view.addGestureRecognizer(swipeRec)
        
    }
    
    func swipedView(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //parse will send a reset email
    //TODO - use our own email service
    @IBAction func resetButtonPressed(sender: AnyObject) {
        if(emailTextField.text != ""){
        ProgressHUD.showSuccess("An email containing reset instructions has been sent to \(emailTextField.text)")
        var user = PFUser.requestPasswordResetForEmail(emailTextField.text)
        }
        else{
            ProgressHUD.showError("Email field cannot be empty")
            emailTextField.backgroundColor = UIColor.redColor()
        }
    }
    
}