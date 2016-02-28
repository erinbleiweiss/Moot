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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let btnName = UIButton()
        btnName.setImage(UIImage(named: "menu"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        //        btnName.addTarget(self, action: Selector("action"), forControlEvents: .TouchUpInside)
        
        
        if self.revealViewController() != nil {
            btnName.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: .TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //.... Set Left Bar Button item
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
    
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
