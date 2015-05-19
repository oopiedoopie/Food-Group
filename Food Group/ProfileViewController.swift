//
//  ProfileViewController.swift
//  Food Group
//
//  Created by Eric Cauble on 5/4/15.
//  Copyright (c) 2015 Oopie Doopie. All rights reserved.
//

import Foundation
import Parse


class ProfileViewController: UIViewController
{
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = PFUser.currentUser()
        {
           nameLabel.text = user[PF_USER_FULLNAME] as? String
           loadUserImage(user)
        }
        else
        {
            nameLabel.text = "Please log in"
            self.userImage.image = UIImage(named: "generic_user")
            println("user not logged in")
        }
    }
    


    
    //log out user from Parse, set default values, switch to login view
    @IBAction func logOutUser(sender: AnyObject)
    {
  
        self.userImage.image = UIImage(named: "generic_user")
        ProgressHUD.showSuccess("You have logged out")
        PFUser.logOut()
        self.nameLabel.text = "Logged out"
        self.performSegueWithIdentifier("showLoginVC", sender: nil)
    }
    
    
    func loadUserImage(user: PFUser)
    {
        if let profileImage:PFFile =  user[PF_USER_THUMBNAIL] as? PFFile
        {
            profileImage.getDataInBackgroundWithBlock { (imageData , error)-> Void in
                if !(error != nil)
                {
                    self.userImage.image = UIImage(data: imageData!)
                    
                }
                else
                {
                    self.userImage.image = UIImage(named: "generic_user")
                }
            }
        }
    }
    
    
    deinit{
        println("profile view was deinit")
    }
    
    
}


func mydelay(#seconds:Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
        completion()
    }
}