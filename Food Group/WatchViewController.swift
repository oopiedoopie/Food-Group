//
//  WatchView.swift
//  Food Group
//
//  Created by Eric Cauble on 7/10/15.
//  Copyright (c) 2015 Oopie Doopie. All rights reserved.
//

import Foundation
import WatchKit
class WatchViewController: WKInterfaceController {
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    var i = 0;
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure inteface objects here.
        
        titleLabel.setText("Hello WatchKit! \(i)")
    }
    
    @IBAction func buttonWasPressed() {
        i++
    }
}