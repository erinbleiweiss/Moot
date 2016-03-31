//
//  StatsViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/31/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import PageMenu

class StatsViewController: MootViewController {
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        
        // VC's will be displayed from left to right in the opposite order they 
        // are added to the following array
//        let controllersToGet: [String: String] = [
//            "AchievementVC": "Achievements",
//            "HighScoreVC": "High Scores"
//        ]
//        
//        for (identifier, title) in controllersToGet {
//            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            let controller = storyboard.instantiateViewControllerWithIdentifier(identifier) as UIViewController
//            controller.title = title
//            controllerArray.append(controller)
//        }

        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("AchievementVC") as UIViewController
        controller.title = "Achievements"
        controllerArray.append(controller)
        
        let controller2 = storyboard.instantiateViewControllerWithIdentifier("HighScoreVC") as UIViewController
        controller2.title = "High Scores"
        controllerArray.append(controller2)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(0),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0.1),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .SelectedMenuItemLabelColor(UIColor.blackColor()),
            .SelectionIndicatorColor(UIColor.blueColor())
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        let topMargin = self.view.frame.height * 0.025
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, topMargin, self.view.frame.width, self.view.frame.height - topMargin), pageMenuOptions: parameters)

        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)

    }
    
    override func viewWillAppear(animated: Bool) {
        let tabBar = self.tabBarController as! MootTabBarController
        tabBar.removeCameraButton()
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
