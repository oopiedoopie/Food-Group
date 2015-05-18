//
//  TabBarController.swift
//  Food Group
//
//  Created by Eric Cauble on 5/7/15.
//  Copyright (c) 2015 Oopie Doopie. All rights reserved.
//

import Foundation
import UIKit

public class TabBarController: UITabBarController
{
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        (self.tabBar.items![0] as! UITabBarItem).selectedImage = UIImage(named: "779-users-selected")
        (self.tabBar.items![1] as! UITabBarItem).selectedImage = UIImage(named: "895-user-group-selected")
        (self.tabBar.items![2] as! UITabBarItem).selectedImage = UIImage(named: "851-calendar-selected")
        (self.tabBar.items![3] as! UITabBarItem).selectedImage = UIImage(named: "722-location-pin-selected")
    }
    
    
    
    deinit
    {
        println("TabBarViewController was deinit")
    }
    
    
}