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
        swipeRec.addTarget(self, action: "swipeToPopView")
        self.view.addGestureRecognizer(swipeRec)
    }
    
    //pops current controller
    func swipeToPopView(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //TODO - fix warning from main thread
    @IBAction func resetButtonPressed(sender: AnyObject) {
        if(emailTextField.text != ""){
        ProgressHUD.showSuccess("An email containing reset instructions has been sent to \(emailTextField.text)")
            //parse will send a reset email
        var user = PFUser.requestPasswordResetForEmail(emailTextField.text)
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
            ProgressHUD.showError("Email field cannot be empty")
            emailTextField.backgroundColor = UIColor.redColor()
        }
    }
    
    
    //sets the status bar color to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    deinit{
     println("PasswordResetVC was deninitialized")
    }
    
}