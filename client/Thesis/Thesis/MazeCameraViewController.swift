//
//  MazeCameraViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/23/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

import Alamofire

class MazeCameraViewController: GenericCameraViewController, CameraDelegate {
    
    var color: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func doAfterScan(upc: String) {
        getColor(upc){ responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            self.color = responseObject!
            self.performSegueWithIdentifier("colorScannedSegue", sender: nil)
        }
    }
    
    
    // Get color name from UPC
    func getColor(upc: String, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/image_colors"
        Alamofire.request(.GET, url, parameters: ["upc": upc]).responseJSON { (_, _, result) in
            
            let json = JSON(result.value!)
            if let color = json["dominant_color"].string{
                completionHandler(responseObject: color, error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Not Found", error: result.error as? NSError)
            }
            
            
        }
        
    }
    
    
    // Send product name back to TestLevelViewController via segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destinationVC = segue.destinationViewController as! MazeLevelViewController
        destinationVC.color = self.color
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

