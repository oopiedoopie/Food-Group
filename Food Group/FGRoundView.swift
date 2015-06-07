//
//  FGRoundView.swift
//  Food Group
//
//  Created by Eric Cauble on 6/7/15.
//  Copyright (c) 2015 Oopie Doopie. All rights reserved.
//
import Foundation
import UIKit


class FGRoundView: UIView
{
    //add style to generic UIButton
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1.0
        //set border color the easy way with UIColor extension
        self.layer.borderColor = UIColor(rgba: "#FFFFFF").CGColor
    }
    
    
    
}
