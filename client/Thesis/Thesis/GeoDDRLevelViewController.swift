//
//  GeoDDRLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/30/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//


import UIKit
import CoreLocation
import Away

class GeoDDRLevelViewController: GenericLevelViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var gotLocation = false
    var originLat: Double = 0
    var originLong: Double = 0
    var currentLocation: CLLocation?
    var destination: CLLocation?
    
    var currentLat: Double = 0
    var currentLong: Double = 0
    
    var dLat: Double = 0
    var dLong: Double = 0
    
    
    let controller: GeoDDRGameController
    required init?(coder aDecoder: NSCoder){
        controller = GeoDDRGameController()
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 4
        
        let gameView = UIView(frame: CGRectMake(0, yOffset, ScreenWidth, ScreenHeight - yOffset))
        self.view.addSubview(gameView)
        self.controller.gameView = gameView
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            let locationUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GeoDDRLevelViewController.updateLocation), userInfo: nil, repeats: true)

        }
        
        
    }

    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if !gotLocation{
            self.originLat = locValue.latitude
            self.originLong = locValue.longitude
            self.gotLocation = true
            
            let current = CLLocation(latitude: originLat, longitude: originLong)
            self.destination = Away.buildLocation(0.5, from: current, bearing: 210)
        }
        
        self.currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        self.currentLat = locValue.latitude
        self.currentLong = locValue.longitude
        
        self.dLat = (currentLat - originLat) * 100000
        self.dLong = (currentLong - originLong) * 100000
        
        print ("dLat: \(self.dLat), dLong: \(self.dLong)")
        
        if self.destination?.distanceFromLocation(self.currentLocation!) <= 0.1 {
            print ("ARRIVED")
        } else {
            print ("not yet arrived")
        }
        
        if (self.dLat > 0){
            print("NORTH")
        }
        if (self.dLat < 0){
            print("SOUTH")
        }
        if (self.dLong > 0){
            print("EAST")
        }
        if (self.dLong < 0){
            print("WEST")
        }
        print("")
        print("")
        print("")
//
        // This should match your CLLocationManager()
        locationManager.stopUpdatingLocation()
        
        
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
