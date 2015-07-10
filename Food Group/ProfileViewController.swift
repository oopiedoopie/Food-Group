//
//  ProfileViewController.swift
//  Food Group
//
//  Created by Eric Cauble on 5/4/15.
//  Copyright (c) 2015 Oopie Doopie. All rights reserved.
//


import Foundation
import UIKit
import Parse


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK: - Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var events:[PFObject] = []
    
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        userImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        if let user = PFUser.currentUser()
        {
            nameLabel.text = user[PF_USER_FULLNAME] as? String
            loadUserImage(user)
            loadEvents(user)
        }
        else
        {
            nameLabel.text = "Please log in"
            self.userImage.image = UIImage(named: "generic_user")
            //if user gets to this view without authentication
            self.performSegueWithIdentifier("showWelcomeVC", sender: nil)
        }
    }
    
    
    func loadEvents(user: PFUser) {
        
        var query = PFQuery(className:"Event")
        //query.where
        query.whereKey("Owner", equalTo: user.objectId!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Found objects in query
                 if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.events.append(object)
                        self.tableView.reloadData()
                    }
                }
            }
            else
            {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }

    
    //log out user from Parse, set default values, switch to login view
    @IBAction func logOutUser(sender: AnyObject)
    {
        self.userImage.image = UIImage(named: "generic_user")
        ProgressHUD.showSuccess("You have logged out")
        PFUser.logOut()
        self.nameLabel.text = "Logged out"
        //send user back to initial view
        self.performSegueWithIdentifier("showWelcomeVC", sender: nil)
    }

    
    func loadUserImage(user: PFUser)
    {
        //check to see if image exists before trying to load it
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
    
    //MARK: - TableView methods
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = self.events[indexPath.row].objectForKey(PF_EVENT_TITLE) as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - Helper methods

    //sets the status bar color to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    deinit{
        println("profile view was deinitialized")
    }
    
    
}
