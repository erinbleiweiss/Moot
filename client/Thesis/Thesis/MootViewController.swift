//
//  MootViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/28/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class MootViewController: UIViewController {
    var hostname = Networking.networkConfig.hostname
    var rest_prefix = Networking.networkConfig.rest_prefix
    
    var displayCamera: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    
    /**
     Wrapper around Apple's dispatch_after() function in order to execute a code
     block after a specified amount of time
     
     - Parameters:
     - delay: (Double) time in seconds
     
     - Returns: none
     
     */
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
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
