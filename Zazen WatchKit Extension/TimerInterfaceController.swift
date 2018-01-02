
//
//  TimerInterfaceController.swift
//  Zazen WatchKit Extension
//
//  Created by dmp on 12/29/17.
//  Copyright © 2017 zenbf. All rights reserved.
//

import WatchKit
import Foundation

class TimerInterfaceController: WKInterfaceController {

    @IBOutlet var _timerControl: WKInterfaceTimer!
    
    override func awake(withContext context: Any?) {
        
        super.awake(withContext: context)
        
        if(context != nil) {
        
            let session = context as! Session
        
            _timerControl.setDate(Date(timeIntervalSinceNow: session.duration ))
        
            _timerControl.start()
            
        }
        
    }

    override func willActivate() {
        
        super.willActivate()
    }

    override func didDeactivate() {
        
        super.didDeactivate()
    }

}
