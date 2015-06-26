//
//  LocationSearchController.swift
//  Food Group
//
//  Created by Eric Cauble on 3/3/15.
//  Copyright (c) 2015 Eric Cauble. All rights reserved.
//

import UIKit
import MapKit


class LocationSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: SBGestureTableView!
    var objects = NSMutableArray()
    let checkIcon = FAKIonIcons.ios7ComposeIconWithSize(30)
    let closeIcon = FAKIonIcons.ios7ComposeIconWithSize(30)
    let composeIcon = FAKIonIcons.ios7ComposeIconWithSize(30)
    let clockIcon = FAKIonIcons.ios7ComposeIconWithSize(30)
    let greenColor = UIColor(red: 85.0/255, green: 213.0/255, blue: 80.0/255, alpha: 1)
    let redColor = UIColor(red: 213.0/255, green: 70.0/255, blue: 70.0/255, alpha: 1)
    let yellowColor = UIColor(red: 236.0/255, green: 223.0/255, blue: 60.0/255, alpha: 1)
    let brownColor = UIColor(red: 182.0/255, green: 127.0/255, blue: 78.0/255, alpha: 1)
    var matchingItems : [MKMapItem] = [MKMapItem]()
    var userLocationManger = CLLocationManager()
    var data = MKMapItem()
    var removeCellBlock: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!
    var addCellBlock: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!

    var itemDict = NSDictionary()
    
  
    // MARK: - initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);

        userLocationManger.desiredAccuracy = kCLLocationAccuracyBest;
        userLocationManger.distanceFilter = kCLDistanceFilterNone;
        userLocationManger.startUpdatingLocation()
        
        setupIcons()
        tableView.didMoveCellFromIndexPathToIndexPathBlock = {(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) -> Void in
            self.objects.exchangeObjectAtIndex(toIndexPath.row, withObjectAtIndex: fromIndexPath.row)
        }
        
        removeCellBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            let indexPath = tableView.indexPathForCell(cell)
            ProgressHUD.showError("Removed cell for \n \(self.matchingItems[indexPath!.row].name)")
            self.matchingItems.removeAtIndex(indexPath!.row)
            tableView.removeCell(cell, duration: 0.3, completion: nil)
        }

        addCellBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            let indexPath = tableView.indexPathForCell(cell)
            ProgressHUD.showSuccess("Added cell for \n \(self.matchingItems[indexPath!.row].name)")
            self.matchingItems.removeAtIndex(indexPath!.row)
            tableView.removeCell(cell, duration: 0.3, completion: nil)
        }
    }
    
    
  
    func setupIcons() {
        checkIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        closeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        composeIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        clockIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
    }
    
    func insertNewObject(sender: AnyObject) {
        objects.insertObject(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showDetail")
        {
            var detailView = segue.destinationViewController as! LocationDetailViewController;
            detailView.itemDetail = self.data
        }
    }
    
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let size = CGSizeMake(30, 30)
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! SBGestureTableViewCell
        cell.firstLeftAction = SBGestureTableViewCellAction(icon: checkIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: addCellBlock)
        cell.secondLeftAction = SBGestureTableViewCellAction(icon: closeIcon.imageWithSize(size), color: greenColor, fraction: 0.6, didTriggerBlock: addCellBlock)
        cell.firstRightAction = SBGestureTableViewCellAction(icon: composeIcon.imageWithSize(size), color: redColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
        cell.secondRightAction = SBGestureTableViewCellAction(icon: clockIcon.imageWithSize(size), color: redColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
        
        itemDict = matchingItems[indexPath.row].placemark.addressDictionary
        var street : String = itemDict.valueForKey("Street") as! String
        var city : String = itemDict.valueForKey("City") as! String
        var state : String = itemDict.valueForKey("State") as! String
        var zip : String = itemDict.valueForKey("ZIP") as! String
       // cell.addressLabel.text = "\(street), \(city), \(state) \(zip)"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        var distanceInMeters : Double = self.userLocationManger.location.distanceFromLocation(matchingItems[indexPath.row].placemark.location)
        var distanceInMiles : Double = ((distanceInMeters.description as String).doubleValue * 0.00062137)
        //cell.distanceLabel.text = "\(distanceInMiles.string(2)) miles away"
        
        let item = matchingItems[indexPath.row] as MKMapItem
        cell.textLabel!.text = item.name
        return cell
    }
    
    
     func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        data = self.matchingItems[indexPath.row]
        self.performSegueWithIdentifier("showDetail", sender: self.view)
        println("row \(indexPath.row)")
     }
    
 
    
    // MARK: - Search functions
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //self.tableView.reloadData()
 
        //TODO: - Fill the tableview with results after three characters have been entered
        if(count(searchBar.text) < 3){
            
            //tableView.reloadData()
        }
        else{
            
        }
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let locationSpan = MKCoordinateSpanMake(0.5, 0.5)
        var coordinate = CLLocationCoordinate2DMake(userLocationManger.location.coordinate.latitude, userLocationManger.location.coordinate.longitude)
        let userRegion = MKCoordinateRegionMake(coordinate, locationSpan)
        let request = MKLocalSearchRequest()
        request.region = userRegion
        
        //add query here
        request.naturalLanguageQuery = searchBar.text
        let search = MKLocalSearch(request: request)
        
        //here's where we search and iterate through the results
        search.startWithCompletionHandler({(response: MKLocalSearchResponse!, error: NSError!) in
            if (error != nil)
            {
                //error
                ProgressHUD.showError(error.description as String, interaction: true)

            }
            else if (response.mapItems.count == 0)
            {
                ProgressHUD.showError("No matches were found.", interaction: true)
              
            }
            else
            {
                //add our MKMapItems items to the matchingItems array
                for item in response.mapItems as! [MKMapItem!]
                {
                    self.matchingItems.append(item)
                }
                //once we have the array, we tell the table to fill with the results
                ProgressHUD.showSuccess("Found \(self.matchingItems.count) matches")
                self.tableView.reloadData()
            }
        })
        //tells the keyboard to go away once you hit search
        searchBar.resignFirstResponder()

    }

    // MARK: - default class methods

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
//ends class LocationSearchViewController



// MARK: - Extensions

//get string value of double without casting
extension String {
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}


//formats a double's decimal places
extension Double {
    func string(fractionDigits:Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.stringFromNumber(self)!
    }
}

