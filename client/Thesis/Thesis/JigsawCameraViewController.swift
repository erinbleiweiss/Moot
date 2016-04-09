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
        self.clearResponse()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.clearResponse()
    }
    
    /**
        Reset upc on load
     */
    func clearResponse(){
        self.response = ""
    }
    
    
    override func doAfterScan(detectionString: String) {
        self.response = detectionString
        self.performSegueWithIdentifier("jigsawScannedSegue", sender: nil)
    }


    
    // Send product name back to JigsawLevelViewController via segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let _ = response{
            let destinationVC = segue.destinationViewController as! JigsawLevelViewController
            destinationVC.response = self.response
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
