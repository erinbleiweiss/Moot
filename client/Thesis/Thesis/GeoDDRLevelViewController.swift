//
//  GeoDDRLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/15/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class GeoDDRLevelViewController: GenericLevelViewController, CLLocationManagerDelegate {
    
    var locManager: CLLocationManager!
    var stepsTaken:[Int] = []

    
    var startDate = NSDate()
    var stepsLabel = UILabel()
    var distanceLabel = UILabel()
    let pedometer = CMPedometer()

    let lengthFormatter = NSLengthFormatter()

    
    let controller: GeoDDRGameController
    required init?(coder aDecoder: NSCoder){
        controller = GeoDDRGameController()
        super.init(coder: aDecoder)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 5
        
        self.startDate = NSDate()
        
        self.setUpArrows()

        self.locManager = CLLocationManager()
        self.locManager.delegate = self
//        self.locManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locManager.requestAlwaysAuthorization()
        self.locManager.startUpdatingHeading()
        
//        self.controller.arrows.activateArrow("east")
//        self.delay(3.5){
//            self.controller.arrows.flashArrow("east")
//            self.delay(2){
//                self.controller.arrows.deactivateArrow("east")
//                self.controller.arrows.activateArrow("north")
//            }
//        }
        
        self.stepsLabel = UILabel(frame: CGRectMake(0, 60, ScreenWidth, 50))
        self.stepsLabel.textAlignment = .Center
        self.stepsLabel.text = "0"
        self.view.addSubview(stepsLabel)
        
        self.distanceLabel = UILabel(frame: CGRectMake(0, 110, ScreenWidth, 50))
        self.distanceLabel.textAlignment = .Center
        self.distanceLabel.text = "0"
        self.view.addSubview(distanceLabel)

        
        lengthFormatter.numberFormatter.usesSignificantDigits = false
        lengthFormatter.numberFormatter.maximumSignificantDigits = 2
        lengthFormatter.unitStyle = .Short
        
//        self.pedometer.startPedometerUpdatesFromDate(NSDate()) {
//            (data, error) in
//            if error != nil {
//                print("There was an error obtaining pedometer data: \(error)")
//            } else {
//                dispatch_async(dispatch_get_main_queue()) {
//                    print(data!.numberOfSteps)
//                    self.stepsLabel.text = "\(data!.numberOfSteps)"
//                    self.distanceLabel.text = "\(self.lengthFormatter.stringFromMeters(data!.distance as! Double))"
//                }
//            }
//        }
        
        let pedometerTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GeoDDRLevelViewController.updatePedometer), userInfo: nil, repeats: true)

    }
    
    func updatePedometer(){
        
        self.pedometer.queryPedometerDataFromDate(startDate, toDate: NSDate(), withHandler:{
            data, error in
                print(data!.numberOfSteps)
                self.stepsLabel.text = "\(data!.numberOfSteps)"
                self.distanceLabel.text = "\(self.lengthFormatter.stringFromMeters(data!.distance as! Double))"
        })
        

    }
    
    
    
    func setUpArrows() {
        let size = ScreenWidth * 0.95
        let arrowsFrame = CGRect(
            x: (ScreenWidth / 2) - (size / 2),
            y: yOffset + (visibleHeight / 2) - (size / 2),
            width: size,
            height: size
        )
        self.controller.arrows = DDRArrowsView(frame: arrowsFrame)
        self.view.addSubview(self.controller.arrows)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let dir = newHeading.magneticHeading
//        print(dir)

        if (310...360 ~= dir) || (0...40 ~= dir) {
            self.controller.arrows.outlineArrow("north")
        } else if 40...140 ~= dir{
            self.controller.arrows.outlineArrow("east")
        } else if 140...220 ~= dir {
            self.controller.arrows.outlineArrow("south")
        } else if 220...310 ~= dir {
            self.controller.arrows.outlineArrow("west")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
