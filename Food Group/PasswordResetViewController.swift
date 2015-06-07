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
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func resetButtonPressed(sender: AnyObject) {
        ProgressHUD.showSuccess("An email containing reset instructions has been sent to \(emailTextField.text)")
        var user = PFUser.requestPasswordResetForEmail(emailTextField.text)

    }
    
}