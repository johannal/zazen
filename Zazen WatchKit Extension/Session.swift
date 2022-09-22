//
//  Session.swift
//  Zazen WatchKit Extension
//
//  Created by dmp on 12/29/17.
//  Copyright © 2017 zenbf. All rights reserved.
//

import WatchKit
import HealthKit
import Foundation

class Session : NSObject, HKWorkoutSessionDelegate {
    
    var duration: Int!
    var startDate : Date?;
    var endDate : Date?;
    var workoutSession : HKWorkoutSession?;
    var isRunning : Bool! = false;
    
    private var _timer : Timer?;
    private let _healthStore = HKHealthStore();
    
    init(duration: Int) {
        
        super.init();
        
        self.duration = duration;
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .mindAndBody
        configuration.locationType = .unknown
        
        do {
            // do something
            workoutSession = try HKWorkoutSession(configuration: configuration)
            workoutSession!.delegate = self
            
            let hkTypesToRead = Set([HKObjectType.categoryType(forIdentifier: .mindfulSession)!])
            let hkTypesToWrite = Set([HKSampleType.categoryType(forIdentifier: .mindfulSession)!])
            
            _healthStore.requestAuthorization(
                toShare: hkTypesToWrite,
                read: hkTypesToRead,
                completion: { (success, error) in
                    print("permissions");
            })
            
            
        } catch let error as NSError {
            // Perform proper error handling here...
            fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
        }
    }
    
    func start() {
        
        if(!self.isRunning) {
            
            startDate = Date();
            
            endDate = startDate!.addingTimeInterval(Double(duration));
        
            _healthStore.start(workoutSession!);
            
            createTimer();
            
            self.isRunning = true;
        }
        else {
            print("called start on running session")
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print(toState.rawValue);
        print(fromState.rawValue);
        print(workoutSession.startDate ?? Date());
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
        print(error);

    }
    
    func end() {
        
        //#todo: this is a terrible hack to stop dups in healthkit until we are remove our good friend wkitimerinterface!
        if(!self.isRunning) {
            print("called end on unrunning session");
            return;
        }
        
/*
         #todo: it isn't clear what this is for, it doesn't appear to work with the .mindandbody type
         
         let wo = HKWorkout(activityType: .mindAndBody, start: self.startDate!, end: self.endDate!)
        
        _healthStore.save(wo) { _,_ in }
        _healthStore.add([sample], to: wo) { _,_ in }
 
 */
        guard let mindfulType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession) else {
            fatalError("*** Unable to create a distance type ***")
        }
       
        let sample = HKCategorySample(type: mindfulType, value: 0, start: startDate!, end: endDate!)
        
        _healthStore.save([sample]) { _,_ in }
        
        _healthStore.end(workoutSession!)
        
        invalidate();
        
    }
    
    func createTimer() {
        
        _timer = Timer.scheduledTimer(timeInterval: 300, target:self, selector: #selector(Session.notify), userInfo: nil, repeats: true)
    }
    
    @objc public func notify()  {
        
        DispatchQueue.main.sync {
            WKInterfaceDevice.current().play(WKHapticType.success);
        }
        
        print("haptic invoked");
    }
    
    func invalidate() {
        
        _timer!.invalidate();
        self.isRunning = false;
        
    }
}
