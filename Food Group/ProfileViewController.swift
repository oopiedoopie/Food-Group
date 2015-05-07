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
    


    
 
    @IBAction func logOutUser(sender: AnyObject)
    {
        PFUser.logOut()
        self.userImage.image = UIImage(named: "generic_user")
        ProgressHUD.showSuccess("You have logged out")
        nameLabel.text = "Logged out"
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
    
    
    
}