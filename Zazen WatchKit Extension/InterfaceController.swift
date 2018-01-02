//
//  InterfaceController.swift
//  Zazen WatchKit Extension
//
//  Created by Douglas Purdy on 12/27/17.
//  Copyright © 2017 zenbf. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBAction func onFortyMinuteStartPress() {
        
        NSLog("onFortyMinuteStartPress");
        
        startSession(duration: 40.0 * 60);
    
    }
    
    @IBAction func onThirtyMinuteStartPress() {
        
        NSLog("onThirtyMinuteStartPress");
        
        startSession(duration: 30.0 * 60);
    }
    
    @IBAction func onTenMinutesStartPress() {
        
        NSLog("onTenMinutesStartPress");
        
        startSession(duration: 10.0 * 60);
    }
    
    func startSession(duration: Double) {
        
        let session = Session(duration: duration)
        
        self.presentController(withName: "TimerInterfaceController", context: session as AnyObject)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
