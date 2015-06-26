//
//  ViewController.swift
//  LE SearchTest
//
//  Created by Eric Cauble on 3/3/15.
//  Copyright (c) 2015 Eric Cauble. All rights reserved.
//

import UIKit
import MapKit


class LocationDetailViewController: UIViewController, UITextFieldDelegate {
    
    //outlets to storyboard
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var urlButton: UIButton!
    
    //variables
    var userLocationManger = CLLocationManager()
    var itemDetail : MKMapItem = MKMapItem()
    var itemDict = NSDictionary()
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationSpan = MKCoordinateSpanMake(1.0, 1.0)
        var coordinate = CLLocationCoordinate2DMake(userLocationManger.location.coordinate.latitude, userLocationManger.location.coordinate.longitude)
        let userRegion = MKCoordinateRegionMake(coordinate, locationSpan)
        mapView.setRegion(userRegion, animated: true)
        mapView.showsUserLocation = true
        mapView.addAnnotation(itemDetail.placemark)
        nameLabel.text = itemDetail.name
        
        
        //create a dictionary to load address data
        itemDict = itemDetail.placemark.addressDictionary

        //extract values from the dictionary
        var street : String = itemDict.valueForKey("Street") as! String
        var city : String = itemDict.valueForKey("City") as! String
        var state : String = itemDict.valueForKey("State") as! String
        var zip : String = itemDict.valueForKey("ZIP") as! String
        locationLabel.text = "\(street), \(city), \(state) \(zip)"
        //TODO: change to call, or format number to "(###) ###-####"
        phoneNumberButton.setTitle(self.formatPhoneNumber(self.itemDetail.phoneNumber) as String, forState: nil)
        
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
   
    
    @IBAction func callNumber(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(itemDetail.phoneNumber)")!)
        
    }
    
    
    @IBAction func openURL(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "\(itemDetail.url)")!)
    }
    

    
    func formatPhoneNumber(itemNumber: String) -> NSString{
        var temp = itemNumber.substringWithRange(Range<String.Index>(start: advance(itemNumber.startIndex, 2), end: advance(itemNumber.endIndex, 0)))
        let currentValue: NSString = temp as String
        let strippedValue: NSString = currentValue.stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: .RegularExpressionSearch, range: NSMakeRange(0, currentValue.length))
        var formattedString: NSString = ""
        if strippedValue.length == 0 {
            formattedString = "";
        }
        else if strippedValue.length < 3 {
            formattedString = "(" + (strippedValue as String)
        }
        else if strippedValue.length == 3 {
            formattedString = "(" + (strippedValue as String) + ") "
        }
        else if strippedValue.length < 6 {
            formattedString = "(" + strippedValue.substringToIndex(3) + ") " + strippedValue.substringFromIndex(3)
        }
        else if strippedValue.length == 6 {
            formattedString = "(" + strippedValue.substringToIndex(3) + ") " + strippedValue.substringFromIndex(3) + "-"
        }
        else if strippedValue.length <= 10 {
            formattedString = "(" + strippedValue.substringToIndex(3) + ") " + strippedValue.substringWithRange(NSMakeRange(3, 3)) + "-" + strippedValue.substringFromIndex(6)
        }
        else if strippedValue.length >= 11 {
            formattedString = "(" + strippedValue.substringToIndex(3) + ") " + strippedValue.substringWithRange(NSMakeRange(3, 3)) + "-" + strippedValue.substringWithRange(NSMakeRange(6, 4)) + " x" + strippedValue.substringFromIndex(10)
        }
        return formattedString
    }
    
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    deinit
    {
        println("detail view was deinitialized")
    }
    
}
