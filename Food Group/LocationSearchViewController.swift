//
//  ViewController.swift
//  LE SearchTest
//
//  Created by Eric Cauble on 3/3/15.
//  Copyright (c) 2015 Eric Cauble. All rights reserved.
//





import UIKit
import MapKit

class LocationSearchViewController: UITableViewController,UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate, UISearchDisplayDelegate  {
    
    //MARK: - TODO - this view is not deinitializing itself
    
    
    //MARK: - Instance Variables
    var matchingItems : [MKMapItem] = [MKMapItem]()
    var userLocationManger = CLLocationManager()
    var data = MKMapItem()
    
    let greenColor = UIColor(red: 85.0/255, green: 213.0/255, blue: 80.0/255, alpha: 1)
    let redColor = UIColor(red: 213.0/255, green: 70.0/255, blue: 70.0/255, alpha: 1)
    let yellowColor = UIColor(red: 236.0/255, green: 223.0/255, blue: 60.0/255, alpha: 1)
    let brownColor = UIColor(red: 182.0/255, green: 127.0/255, blue: 78.0/255, alpha: 1)
    var removeCellBlock: ((SBGestureTableView, SBGestureTableViewCell) -> Void)!
    var itemDict = NSDictionary()
    
    //MARK: - Default Class Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        userLocationManger.desiredAccuracy = kCLLocationAccuracyBest;
        userLocationManger.distanceFilter = kCLDistanceFilterNone;
        userLocationManger.startUpdatingLocation()
        
        
        removeCellBlock = {(tableView: SBGestureTableView, cell: SBGestureTableViewCell) -> Void in
            let indexPath = tableView.indexPathForCell(cell)
            self.matchingItems.removeAtIndex(indexPath!.row)
            tableView.removeCell(cell, duration: 0.3, completion: nil)
        }
    }
    
    //test
    
    //MARK: - TableViewMethods
    func insertNewObject(sender: AnyObject) {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchingItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("myCell") as?  SBGestureTableViewCell
        let size = CGSizeMake(30, 30)
        //        cell!.firstLeftAction = SBGestureTableViewCellAction(icon: checkIcon.imageWithSize(size), color: greenColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
        //        cell!.secondLeftAction = SBGestureTableViewCellAction(icon: closeIcon.imageWithSize(size), color: greenColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
        //        cell!.firstRightAction = SBGestureTableViewCellAction(icon: composeIcon.imageWithSize(size), color: redColor, fraction: 0.3, didTriggerBlock: removeCellBlock)
        //        cell!.secondRightAction = SBGestureTableViewCellAction(icon: clockIcon.imageWithSize(size), color: redColor, fraction: 0.6, didTriggerBlock: removeCellBlock)
        // cell!.nameLabel.text = ("\(matchingItems[indexPath.row].name)")
        itemDict = matchingItems[indexPath.row].placemark.addressDictionary
        var street : String = itemDict.valueForKey("Street") as!  String
        var city : String = itemDict.valueForKey("City") as!  String
        var state : String = itemDict.valueForKey("State") as!  String
        var zip : String = itemDict.valueForKey("ZIP") as!  String
        // cell!.addressLabel.text = "\(street), \(city), \(state) \(zip)"
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        var distanceInMeters : Double = self.userLocationManger.location.distanceFromLocation(matchingItems[indexPath.row].placemark.location)
        var distanceInMiles : Double = ((distanceInMeters.description as String).doubleValue * 0.00062137)
        //   cell!.distanceLabel.text = "\(distanceInMiles.string(2)) miles away"
        return cell!
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        //return categoryMatch && (stringMatch != nil)
    }
    
    
    //
    //    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
    //        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as!  [String]
    //        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
    //        self.filterContentForSearchText(searchString, scope: selectedScope)
    //        return true
    //    }
    //
    //    func searchDisplayController(controller: UISearchDisplayController,
    //        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
    //            return true
    //    }
    //
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        data = self.matchingItems[indexPath.row]
        self.performSegueWithIdentifier("showDetailVC", sender: tableView)
        var detailView = DetailViewController()
    }
    
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showDetailVC")
        {
            var detailView = segue.destinationViewController as!  DetailViewController;
            detailView.itemDetail = self.data
        }
    }
    
    
    
    // MARK: - Search functions
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
                var alert = UIAlertView()
                alert.message = "This app needs access to cellular data or a wi-fi network to make searches"
                alert.addButtonWithTitle("OK")
                alert.show()
                println("Error occured in search: \(error.localizedDescription)")
            }
            else if (response.mapItems.count == 0)
            {
                var alert = UIAlertView()
                alert.message = "No matches found for \(searchBar.text)"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
            else
            {
                //add our MKMapItems items to the matchingItems array
                for item in response.mapItems as! [MKMapItem!]
                {
                    self.matchingItems.append(item)
                }
                //once we have the array, we tell the table to fill with the results
                self.tableView.reloadData()
            }
        })
        //tells the keyboard to go away once you hit search
        searchBar.resignFirstResponder()
    }
    
    
    
    //MARK: - Class Deinitializer
    deinit{
        "SearchTableView deinit"
    }
    
}//ends class ViewController


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

