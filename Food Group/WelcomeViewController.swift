//
//  WelcomeViewController.swift
//  Food Group
//
//  Created by Eric Cauble on 4/30/15.
//  Copyright (c) 2015 Oopie Doopie. All rights reserved.
//

import UIKit
import Parse
 


class WelcomeViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //check to see if user is authenticated with Parse, works for Parse and Facebook
        
        if (PFUser.currentUser()?.isAuthenticated() == true){
            println("user is authenticated")
              //we have to async because it happens too fast
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("showProfileVC", sender: nil)
            }
          }
        else
        {
            println("user is NOT authenticated")
             dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("showSignUpVC", sender: nil)
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
     deinit{
        println("welcome view was deinit")
    }
    
}
