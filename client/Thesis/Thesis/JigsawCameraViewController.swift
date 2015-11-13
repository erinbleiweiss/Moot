//
//  DragAndDropCameraViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/8/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class JigsawCameraViewController: GenericCameraViewController, CameraDelegate {

    var response: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func doAfterScan(detectionString: String) {
        checkQRCode(detectionString){ responseObject, error in
            print("responseObject = \(responseObject); error = \(error)")
            self.response = responseObject!
            if self.response == "true" {
                self.response = "SUCCESS!"
            } else {
                self.response = ""
            }
            
            self.performSegueWithIdentifier("jigsawScannedSegue", sender: nil)
        }
    }

    
    // Check whether QR code scanned is the one provided in the jigsaw puzzle
    func checkQRCode(detectionString: String, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = detectionString
        Alamofire.request(.GET, url).responseJSON { (_, _, result) in
            
            let json = JSON(result.value!)
            if let response = json["correcthorsebatterystaple"].string{
               
                completionHandler(responseObject: response, error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Incorrect barcode scanned", error: result.error as? NSError)
            }
            
            
        }
        
    }
    
    // Send product name back to JigsawLevelViewController via segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destinationVC = segue.destinationViewController as! JigsawLevelViewController
        destinationVC.response = self.response
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
