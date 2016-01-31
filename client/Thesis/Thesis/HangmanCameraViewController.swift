//
//  ViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 9/22/15.
//  Copyright (c) 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

import Alamofire
import SwiftyJSON

class HangmanCameraViewController: GenericCameraViewController, CameraDelegate {
    
    var productName: String!  // Name of product scanned
    var upc: String?          // UPC of product scanned

    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    
    override func doAfterScan(upc: String){
//        getProduct(upc){ responseObject, error in3
//            print("responseObject = \(responseObject); error = \(error)")
//            self.productName = responseObject!
//            print(self.productName)
//            self.performSegueWithIdentifier("barcodeScannedSegue", sender: nil)
//        }
        
        // Assign read upc to class
        self.upc = upc
        self.performSegueWithIdentifier("barcodeScannedSegue", sender: nil)
        
        
    }
    
    
    // Get product name from UPC
    func getProduct(upc: String, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/get_product_nameOLD"
        Alamofire.request(.GET, url, parameters: ["upc": upc]).responseJSON { (_, _, result) in
            
            let json = JSON(result.value!)
            if let name = json["product_name"].string{
                completionHandler(responseObject: name, error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Not Found", error: result.error as? NSError)
            }
            
            
        }
        
    }
    
    
    // Send data back to TestLevelViewController via segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // If UPC defined
        if let _ = upc{
            let destinationVC = segue.destinationViewController as! HangmanLevelViewController
            destinationVC.controller.upc = self.upc!
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

