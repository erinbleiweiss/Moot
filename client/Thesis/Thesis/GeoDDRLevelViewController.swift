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
    
    var timerLabel: UILabel!
    var timer: Timer!

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
        self.timerLabel = UILabel(frame: CGRectMake(0, y, ScreenWidth, height))
//        self.timerLabel.sizeLabel()
        self.timerLabel.textAlignment = .Center
        self.timerLabel.textColor = mootBlack
        self.timerLabel.text = ""
        self.view.addSubview(self.timerLabel)
        
//        let duration = Utils.getTotalDurationInSeconds(textTimeInMinutesAndSeconds: textTime!.text);
//        timer = Timer(duration: duration ){
//
//        }
        
        
    }
    

    
    override func viewDidDisappear(animated: Bool) {
//        locationManager.stopUpdatingLocation()
//        locationUpdateTimer!.invalidate()
//        locationUpdateTimer = nil
    }
    
}
