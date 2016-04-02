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
import SwiftyJSON

class MazeCameraViewController: GenericCameraViewController, CameraDelegate {
    
    var upc: String?          // UPC of product scanned

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func doAfterScan(upc: String) {
        self.upc = upc
        self.performSegueWithIdentifier("colorScannedSegue", sender: nil)

    }
    
    

    
    // Send product name back to MazeLevelViewController via segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let _ = upc{
            let destinationVC = segue.destinationViewController as! MazeLevelViewController
            destinationVC.upc = self.upc!
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

