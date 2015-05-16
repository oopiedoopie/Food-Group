//
//  LocationSearchController.swift
//  Food Group
//
//  Created by Eric Cauble on 3/3/15.
//  Copyright (c) 2015 Eric Cauble. All rights reserved.
//




import UIKit
import MapKit


//
//  LocationSearchViewController.swift
//  LE SearchTest
//
//  Created by Eric Cauble on 3/3/15.
//  Copyright (c) 2015 Eric Cauble. All rights reserved.
//


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
    var itemDict = NSDictionary()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // MARK: - initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        userLocationManger.desiredAccuracy = kCLLocationAccuracyBest;
        userLocationManger.distanceFilter = kCLDistanceFilterNone;
        userLocationManger.startUpdatingLocation()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        navigationItem.rightBarButtonItem = addButton
        
        setupIcons()
        tableView.didMoveCellFromIndexPathToIndexPathBlock = {(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) -> Void in
            self.objects.exchangeObjectAtIndex(toIndexPath.row, withObjectAtIndex: fromIndexPath.row)
        }
        
        removeCellBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            let indexPath = tableView.indexPathForCell(cell)
            
            ProgressHUD.showSuccess("Removed cell for \n \(self.matchingItems[indexPath!.row].name)")
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row] as! NSDate
               // (segue.destinationViewController as! LocationDetailViewController).detailItem = object
               // tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
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
        
        cell.firstLeftAction = SBGestureTableViewCellAction(icon: checkIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
        cell.secondLeftAction = SBGestureTableViewCellAction(icon: closeIcon.imageWithSize(size), color: redColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
        cell.firstRightAction = SBGestureTableViewCellAction(icon: composeIcon.imageWithSize(size), color: yellowColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
        cell.secondRightAction = SBGestureTableViewCellAction(icon: clockIcon.imageWithSize(size), color: brownColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
        
        let item = matchingItems[indexPath.row] as MKMapItem
        cell.textLabel!.text = item.name
        return cell
    }
    
    
    // MARK: - Search functions
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // self.insertNewObject(searchBar.text)
        self.tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //create a location, for now we manually add lat/lon coordinates (these are for mauldin high)
        
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
                //assume that they aren't connected to the internet
                ProgressHUD.showError("No matches found 😁", interaction: true)

            }
            else if (response.mapItems.count == 0)
            {
                var alert = UIAlertView()
                ProgressHUD.showError("No matches found!", interaction: true)
              
            }
            else
            {
                //add our MKMapItems items to the matchingItems array
                for item in response.mapItems as! [MKMapItem!]
                {
                    println(item.name)
                    self.matchingItems.append(item)
                }
                //once we have the array, we tell the table to fill with the results
                self.tableView.reloadData()
                ProgressHUD.showSuccess("Found \(self.matchingItems.count) matches")
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

