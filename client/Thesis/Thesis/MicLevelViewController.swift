//
//  MicLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/15/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class MicLevelViewController: GenericLevelViewController {

    let controller: MicGameController
    required init?(coder aDecoder: NSCoder){
        controller = MicGameController()
        super.init(coder: aDecoder)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 6
        
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
