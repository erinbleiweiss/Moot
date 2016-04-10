//
//  TimerLabel.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/9/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit

class TimerLabel: UILabel{
    
    var duration: NSTimeInterval!
    var endTime: NSDate!
    
    func update(){
        var remainingTime = timeLeft()
        
        let minutes = UInt8(remainingTime / 60.0)
        remainingTime -= (NSTimeInterval(minutes) * 60)

        let seconds = UInt8(remainingTime)
        remainingTime -= NSTimeInterval(seconds)
        
        let fraction = UInt8(remainingTime * 100)
                
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        self.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    func startWithDuration(duration: NSTimeInterval){
        self.duration = duration
        let timeNow = NSDate()
        self.endTime = timeNow.dateByAddingTimeInterval(self.duration)
    }
    
    func hasFinished() -> Bool{
        return timeLeft() == 0
    }
    
    func timeLeft() -> NSTimeInterval {
        let now = NSDate()
        let remainingSeconds = endTime.timeIntervalSinceDate(now)
        return max(remainingSeconds, 0)
    }
    
    
    func resetTimer(){
        let timeNow = NSDate()
        self.endTime = timeNow.dateByAddingTimeInterval(self.duration)
    }
    
}