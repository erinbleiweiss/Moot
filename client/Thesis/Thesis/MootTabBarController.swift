//
//  MootTabBarController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/22/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

public class MootTabBarController: UITabBarController {

    var setupEmptyTab: Bool = false
    var cameraVC: String?
    var cameraButtonVisible: Bool = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        UITabBar.appearance().barTintColor = color

    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !setupEmptyTab{
            // Insert empty tab item at center index.
            self.insertEmptyTabItem("", atIndex: 1)
            self.setupEmptyTab = true
        }
    }
    


    public func insertEmptyTabItem(title: String, atIndex: Int) {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: title, image: nil, tag: 0)
        vc.tabBarItem.enabled = false
        
        self.viewControllers?.insert(vc, atIndex: atIndex)
    }
    
    
    public func createRaisedButton(buttonImage: UIImage?, highlightImage: UIImage?) {
        if let buttonImage = buttonImage {
            let button = CameraTabButton(type: UIButtonType.Custom)
            button.tag = 1337
            button.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin]
            
            button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height)
//            button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
//            button.setBackgroundImage(highlightImage, forState: UIControlState.Highlighted)
            
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
            let img = UIImage(named: "camerabutton")
            self.createRaisedButton(img, highlightImage: nil)
            self.cameraButtonVisible = true
        }
    }
    
    func removeCameraButton(){
        if let button = self.view.viewWithTag(1337) as? CameraTabButton {
            button.animation = "squeezeUp"
            button.force = 0.1
            button.animateToNext(){
                button.removeFromSuperview()
            }
            self.view.setNeedsDisplay()
            self.cameraButtonVisible = false
        } else {
            print("no button for tag")
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
