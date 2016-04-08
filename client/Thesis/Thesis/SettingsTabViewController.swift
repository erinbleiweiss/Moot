//
//  SettingsTabViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/6/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import PageMenu

class SettingsTabViewController: MootViewController {

    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("SettingsVC") as UIViewController
        controller.title = "Settings"
        controllerArray.append(controller)
        
        let controller2 = storyboard.instantiateViewControllerWithIdentifier("HelpVC") as UIViewController
        controller2.title = "About"
        controllerArray.append(controller2)

        let controller3 = storyboard.instantiateViewControllerWithIdentifier("PrivacyVC") as UIViewController
        controller3.title = "Privacy Policy"
        controllerArray.append(controller3)
        
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
