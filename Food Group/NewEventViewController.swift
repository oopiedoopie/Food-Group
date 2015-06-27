//
//  NewEventController.swift
//  Food Group
//
//  Created by Eric Cauble on 5/17/15.
//  Copyright (c) 2015 Oopie Doopie. All rights reserved.
//

import Parse
import Foundation
import UIKit

class NewEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UIButton!
    @IBOutlet weak var endTimeTextField: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Varibales
    var datePicker = DatePickerDialog()
    var startTime = NSDate()
    var endTime = NSDate()
    var users = [PFUser]()
    var selection = [String]()
    var delegate: SelectMultipleViewControllerDelegate!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //This stops dismisskeyboard reconizer from interfering with the tableview selections
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
        self.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadUsers()
    }
    
    func loadUsers() {
        let user = PFUser.currentUser()
        var query = PFQuery(className: PF_USER_CLASS_NAME)
        query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
        query.orderByAscending(PF_USER_FULLNAME)
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                self.users.removeAll(keepCapacity: false)
                self.users += objects as! [PFUser]!
                self.tableView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
            }
        }
    }
    
    
    //MARK: - Actions
    @IBAction func startTimeTouched(sender: AnyObject)
    {
        DatePickerDialog().show(title: "DatePickerDialog", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            (date) -> Void in
            self.startTimeTextField.setTitle("\(self.formatDate(date))", forState: nil)
            self.startTime = (date)
            //autoset end date an hour later, but it can be manually moved to any time.
            self.endTime = (self.startTime.dateByAddingTimeInterval(1*60*60))
            self.endTimeTextField.setTitle("\(self.formatDate(self.endTime))", forState: nil)
        }
        self.startTimeTextField.resignFirstResponder()
    }
    
    //MARK: - TODO: ensure endTime cannot be before startTime
    @IBAction func endTimeTouched(sender: AnyObject)
    {
        
        DatePickerDialog().show(title: "DatePickerDialog", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
            (date) -> Void in
            self.endTimeTextField.setTitle("\(self.formatDate(date))", forState: nil)
            self.endTime = (date)
        }
        self.endTimeTextField.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showInviteVC")
        {
//            var inviteView = segue.destinationViewController as! InviteController;
//            inviteView.eventTitle = eventTitleTextField.text
//            inviteView.eventStart = startTime
//            inviteView.eventEnd = endTime
        }
    }
    
    //returns a String in the correct date format
    func formatDate(eventTime : NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        var time = "\(dateFormatter.stringFromDate(eventTime)), \(timeFormatter.stringFromDate(eventTime))"
        return time
    }
    
    
   
    // MARK: - TableView Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user[PF_USER_FULLNAME] as? String
        
        let selected = contains(self.selection, user.objectId!)
        cell.accessoryType = selected ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let user = self.users[indexPath.row]
        let selected = contains(self.selection, user.objectId!)
        if selected {
            if let index = find(self.selection, user.objectId!) {
                self.selection.removeAtIndex(index)
            }
        } else {
            self.selection.append(user.objectId!)
        }
        
        self.tableView.reloadData()
    }
    
    
    //MARK: - Actions
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func createNewGroup(sender: AnyObject) {
        for user in selection{
            println(user)
        }
        println()
    }
    
    
    
    //MARK: - Helper Methods
    func dismissKeyboard() {
        self.view.endEditing(true)

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        eventTitleTextField.resignFirstResponder()
        return true;
    }

    deinit{
        println("NewEventViewController was deninitialized")
    }
}