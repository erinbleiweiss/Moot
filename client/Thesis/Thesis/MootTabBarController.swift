//
//  MootTabBarController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/22/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

public class MootTabBarController: RAMAnimatedTabBarController {

    var cameraVC: String?
    var cameraButtonVisible: Bool = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()

//        // turn off top border
//        self.tabBar.barStyle = UIBarStyle.Black
        self.tabBar.translucent = false

//        let color = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        let color = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = color

    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable middle tab bar item
        if  let arrayOfTabBarItems = self.tabBar.items as! AnyObject as? NSArray,tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
            tabBarItem.enabled = false
        }
    }

    
    
    public func createRaisedButton(buttonImage: UIImage?, highlightImage: UIImage?) {
        if let buttonImage = buttonImage {
            let button = CameraTabButton(type: UIButtonType.Custom)
            button.tag = 1337
            button.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin]
            
            let buttonSize = self.tabBar.frame.height * 1.5
            button.frame = CGRectMake(0.0, 0.0, buttonSize, buttonSize)


            let imageOffsetY: CGFloat = buttonSize * 0.05
            let imageFrame = CGRectMake(0, -imageOffsetY, buttonSize, buttonSize)
            button.setImage(buttonImage, inFrame: imageFrame, forState: UIControlState.Normal)
            button.setImage(buttonImage, inFrame: imageFrame, forState: UIControlState.Highlighted)
            
            let heightDifference = buttonImage.size.height - self.tabBar.frame.size.height
            
            if (heightDifference < 0) {
                button.center = self.tabBar.center
            }
            else {
                var center = self.tabBar.center
                center.y -= heightDifference / 2.0
                
                button.center = center
            }
            
            button.addTarget(self, action: "onRaisedButton:", forControlEvents: UIControlEvents.TouchUpInside)
            button.animation = "squeezeUp"
            button.force = 0.5
            button.animate()
            self.view.addSubview(button)
        }
    }
    
    public func onRaisedButton(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let modalVC = storyboard.instantiateViewControllerWithIdentifier(self.cameraVC!) as UIViewController
        self.selectedViewController?.presentViewController(modalVC, animated: true, completion: { () -> Void in
            
            
            print("")
        })
        
    

    }
    

    public func addCameraButton(){
        if !cameraButtonVisible{
            // Raise the center button with image
            let img = UIImage(named: "camera")
            self.createRaisedButton(img, highlightImage: nil)
            self.cameraButtonVisible = true
        }
    }
    
    func removeCameraButton(){
        if let button = self.view.viewWithTag(1337) as? CameraTabButton {
            button.animation = "fadeOut"
            button.duration = 0.5
            button.animate()
            button.animation = "squeezeUp"
            button.force = 0.1
            button.animateToNext(){
                button.removeFromSuperview()
            }
            self.view.setNeedsDisplay()
            self.cameraButtonVisible = false
        }
    }
    
    func setCameraVCForButton(vc: String){
        self.cameraVC = vc
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
    
    override public func didReceiveMemoryWarning() {
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
