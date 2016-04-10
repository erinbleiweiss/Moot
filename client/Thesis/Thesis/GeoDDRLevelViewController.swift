//
//  GeoDDRLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/30/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreMotion

class GeoDDRLevelViewController: GenericLevelViewController, CLLocationManagerDelegate {
    
    var timerLabel: TimerLabel!
    var timer: NSTimer!
    
    let motionManager: CMMotionManager = CMMotionManager()
    var initialAttitude : CMAttitude!

    let controller: GeoDDRGameController
    required init?(coder aDecoder: NSCoder){
        controller = GeoDDRGameController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 4
        
        let y = ScreenHeight * 0.25
        let height = ScreenHeight * 0.5
        self.timerLabel = TimerLabel(frame: CGRectMake(0, y, ScreenWidth, height))
        self.timerLabel.textAlignment = .Center
        self.timerLabel.textColor = mootBlack
        self.timerLabel.font = UIFont(name: "Anonymous", size: 30.0)
        self.timerLabel.text = ""
        self.view.addSubview(self.timerLabel)
        
        self.startTimer(20)
        
        
        var prevX: Double = 1
        var prevY: Double = 1
        var prevZ: Double = 1
        let threshhold = 0.015
        if motionManager.deviceMotionAvailable {
            //sleep(2)
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()){ data, error in
                let magnitude = data!.acceleration
                let x = magnitude.x
                let y = magnitude.y
                let z = magnitude.z
                
                let dx = x - prevX
                let dy = y - prevY
                let dz = z - prevZ
               
                if (dx <= threshhold && dy <= threshhold && dz <= threshhold){
                    print("still")
                } else {
                    print("moved")
                }
                print("")
                
                prevX = x
                prevY = y
                prevZ = z

            }
        
        }
        

    }
    
    
    func startTimer(duration: NSTimeInterval){
        self.timerLabel.startWithDuration(duration)
        self.timerLabel.update()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(self.checkTime), userInfo: nil, repeats: true)
    }
    
    func checkTime(){
        if !self.timerLabel.hasFinished(){
            self.timerLabel.update()
        }
    }
    
    func resetTime(){
        self.timer.invalidate()
        self.timer = nil
        self.timerLabel.resetTimer()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(self.checkTime), userInfo: nil, repeats: true)
    }
    
    
    override func viewDidDisappear(animated: Bool) {
//        locationManager.stopUpdatingLocation()
//        locationUpdateTimer!.invalidate()
//        locationUpdateTimer = nil
    }
    
}
