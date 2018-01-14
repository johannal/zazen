
//
//  TimerInterfaceController.swift
//  Zazen WatchKit Extension
//
//  Created by dmp on 12/29/17.
//  Copyright © 2017 zenbf. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class TimerInterfaceController: WKInterfaceController {

    @IBOutlet var _timerControl: WKInterfaceTimer!
    
    var _timer: Timer!
    var _session: Session!;
    
    override func awake(withContext context: Any?) {
        
        super.awake(withContext: context)
        
        if(context != nil) {
        
            _session = context as! Session
            
            if(_session.workoutSession?.state == HKWorkoutSessionState.notStarted) {
            
                _session.start();
                
            }
            
            _timerControl.setDate(_session.endDate!)
            
            _timerControl.start()
            
        }
        
    }

    override func willActivate() {
        
        super.willActivate()
    }
    
    override func didDeactivate() {
        //todo: this is getting fired N times
        //and there are two session objects now.
        //need to have a singleton session and check here.
        super.didDeactivate()
        
        _session.end();

    }

}
