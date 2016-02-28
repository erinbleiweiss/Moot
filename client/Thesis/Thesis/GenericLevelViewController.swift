//
//  GenericLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/24/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import SwiftHEXColors
import SWRevealViewController

class GenericLevelViewController: MootViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color: UIColor = UIColor(hexString: "#2ecc71")!
        self.view.backgroundColor = color
        // Do any additional setup after loading the view.
        
        
        
        let frame = CGRect(x: 50, y: 100, width: 100, height: 100)
        let customView = ScoreBox(frame: frame)
        customView.backgroundColor = UIColor(white: 1, alpha: 1)
        self.view.addSubview(customView)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


    func provideVCClass() -> UIViewController.Type {
        return GenericLevelViewController.self
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
