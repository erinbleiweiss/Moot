//
//  LevelCompletedViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/21/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Spring
import DynamicColor

class LevelCompletedViewController: MootViewController {

    var sender: UIViewController?
    
    override func viewWillAppear(animated: Bool) {
        let tabBar = self.tabBarController as! MootTabBarController
        tabBar.removeCameraButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scale = ScreenWidth / 320
        
        self.delay(4.5){
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        var x: CGFloat = 0
        var y: CGFloat = ScreenHeight * 0.15
        let width = ScreenWidth
        var height = ScreenHeight * 0.5
        let mainView = SpringView(frame: CGRectMake(x, y, width, height))
        self.view.addSubview(mainView)
        
        self.view.backgroundColor = mootBackground
        
        x = 0
        y = 0
        height = ScreenHeight * 0.25
        let levelLabel = SpringLabel(frame: CGRectMake(x, y, width, height))
        levelLabel.text = "Level"
        levelLabel.textAlignment = .Center
        levelLabel.font = Raleway.Bold.withSize(50 * scale)
        levelLabel.textColor = mootColors["blue"]?.saturatedColor()
        mainView.addSubview(levelLabel)
        
        y += (height / 2)
        
        let completedLabel = SpringLabel(frame: CGRectMake(x, y, width, height))
        completedLabel.text = "Completed"
        completedLabel.textAlignment = .Center
        completedLabel.font = Raleway.Bold.withSize(50 * scale)
        completedLabel.textColor = mootColors["green"]
        
        levelLabel.animation = "squeezeRight"
        levelLabel.delay = 0.5
        levelLabel.force = 1.5
        levelLabel.rotate = 1.5
        levelLabel.duration = 1.5
        levelLabel.animateNext({
            mainView.addSubview(completedLabel)
            completedLabel.animation = "fadeUp"
            completedLabel.force = 1.5
            completedLabel.scaleX = 2.0
            completedLabel.scaleY = 2.0
            completedLabel.y = 100.0
            completedLabel.duration = 1.5
            completedLabel.animateNext({
                mainView.animation = "zoomOut"
                mainView.duration = 1.5
                mainView.animate()
            })
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

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
