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
    var endTime: NSDate!
    
    func update(){
        let timeLeftInteger = Int(timeLeft())
        self.text = String(timeLeftInteger)
    }
    
    func startWithDuration(duration: NSTimeInterval){
        let timeNow = NSDate()
        self.endTime = timeNow.dateByAddingTimeInterval(duration)
    }
    
    func hasFinished() -> Bool{
        return timeLeft() == 0
    }
    
    func timeLeft() -> NSTimeInterval {
        let now = NSDate()
        let remainingSeconds = endTime.timeIntervalSinceDate(now)
        return max(remainingSeconds, 0)
    }
    
}