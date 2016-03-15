//
//  StageCompletedViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/14/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class StageCompletedViewController: MootViewController {

    var sender: UIViewController?
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "HangmanSuccess"
//        {
//            print("yeehaw")
//            
//            if let destinationVC = segue.destinationViewController as? UIViewController{
//                destinationVC.numberToDisplay = counter
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delay(3){
            self.dismissViewControllerAnimated(true, completion: nil)
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
