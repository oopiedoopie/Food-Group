//
//  FGButton.swift
//  FGStyle
//
//  Created by Eric Cauble on 5/30/15.
//  Copyright (c) 2015 Eric Cauble. All rights reserved.
//
//


import Foundation
import UIKit

class FGButton: UIButton
{
    //add style to generic UIButton
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = 5
        
        
        
    }
    
    
}
