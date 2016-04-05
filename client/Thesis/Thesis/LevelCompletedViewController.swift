//
//  LevelCompletedViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/21/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class LevelCompletedViewController: MootViewController {

    var sender: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delay(3){
//            self.dismissViewControllerAnimated(false, completion: nil)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        // Do any additional setup after loading the view.
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
