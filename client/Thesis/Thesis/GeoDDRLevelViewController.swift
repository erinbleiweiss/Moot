//
//  GeoDDRLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/15/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import CoreLocation

class GeoDDRLevelViewController: GenericLevelViewController, CLLocationManagerDelegate {
    
    var locManager: CLLocationManager!

    
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
        

        // Do any additional setup after loading the view.
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
        print(dir)

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
