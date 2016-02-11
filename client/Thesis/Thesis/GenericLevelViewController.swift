//
//  GenericLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/24/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import SwiftHEXColors

class GenericLevelViewController: UIViewController {

    var hostname = Networking.networkConfig.hostname
    var rest_prefix = Networking.networkConfig.rest_prefix

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Add one layer for all game elements (-200 accounts for height of top bar)
//        let gameView = UIView(frame: CGRectMake(0, -200, ScreenWidth, ScreenHeight))
//        self.view.addSubview(gameView)
//        self.controller!.gameView = gameView
        
        let color: UIColor = UIColor(hexString: "#2ecc71")!
        self.view.backgroundColor = color
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
