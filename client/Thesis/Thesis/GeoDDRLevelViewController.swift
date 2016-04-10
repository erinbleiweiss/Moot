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
    
    let scale = ScreenWidth / 320
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 4
        
        let y = ScreenHeight * 0.25
        let height = ScreenHeight * 0.5
        self.timerLabel = TimerLabel(frame: CGRectMake(0, y, ScreenWidth, height))
        self.timerLabel.textAlignment = .Center
        self.timerLabel.textColor = mootBlack
        self.timerLabel.font = UIFont(name: "Droid Sans Mono", size: 40 * scale)
        self.timerLabel.text = ""
        self.view.addSubview(self.timerLabel)
        
        let minutes: Double = 5.0
        self.startTimer(60 * minutes)
        
        
        var prevX: Double = 1
        var prevY: Double = 1
        var prevZ: Double = 1
        let threshhold = 0.015
        motionManager.accelerometerUpdateInterval = 0.01
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
                    // Device is still
                } else {
                    // Device moved
                    self.resetTime()
                }
                
                prevX = x
                prevY = y
                prevZ = z

            }
        
        }
        

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        self.motionManager.stopAccelerometerUpdates()
    }
    
    func startTimer(duration: NSTimeInterval){
        self.timerLabel.startWithDuration(duration)
        self.timerLabel.update()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(self.checkTime), userInfo: nil, repeats: true)
    }
    
    func checkTime(){
        if !self.timerLabel.hasFinished(){
            self.timerLabel.update()
        } else {
            self.timer.invalidate()
            self.timer = nil
            self.motionManager.stopAccelerometerUpdates()
            self.delay(2){
                self.displayLevelCompletionView()
            }
        }
    }
    
    func resetTime(){
        self.timer.invalidate()
        self.timer = nil
        self.timerLabel.resetTimer()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(self.checkTime), userInfo: nil, repeats: true)
    }
    
    
    /**
        Transition to the "Level Completed" controller, then prepare for new nevel
     */
    override func displayLevelCompletionView(){
        if self.controller.level != nil {
            let level = LevelManager.sharedInstance.getLevelByNumber(self.controller.level!)
            let identifier = "\(level.getVCName())Complete"
            self.performSegueWithIdentifier(identifier, sender: nil)
        }
    }
    
    
    override func resetButtonTouched(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Reset", message: "Reset the current level?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let action = UIAlertAction(title: "Reset Level", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            self.controller.resetCurrentLevel()
            self.resetTime()
        })
        alertController.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) in
        })
        alertController.addAction(cancelAction)
        
        
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = sender.frame
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
}
