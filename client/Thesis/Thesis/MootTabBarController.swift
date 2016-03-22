//
//  MootTabBarController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/22/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

public class MootTabBarController: UITabBarController {

    var cameraButton: UIButton?
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
            // Insert empty tab item at center index.
            self.insertEmptyTabItem("", atIndex: 1)
        
            // Raise the center button with image
            let img = UIImage(named: "icon_camera")
            self.createRaisedButton(img, highlightImage: nil)
    }
    
    

    public func insertEmptyTabItem(title: String, atIndex: Int) {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: title, image: nil, tag: 0)
        vc.tabBarItem.enabled = false
        
        self.viewControllers?.insert(vc, atIndex: atIndex)
    }
    
    
    public func createRaisedButton(buttonImage: UIImage?, highlightImage: UIImage?) {
        if let buttonImage = buttonImage {
            let button = UIButton(type: UIButtonType.Custom)
            button.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin]
            
            button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height)
            button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
            button.setBackgroundImage(highlightImage, forState: UIControlState.Highlighted)
            
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
            self.cameraButton = button
        }
    }
    
    public func onRaisedButton(sender: UIButton!) {
        
    }
    

    func addCameraButton(){
        self.view.addSubview(self.cameraButton!)
        self.view.setNeedsDisplay()
    }
    
    func removeCameraButton(){
        self.cameraButton!.removeFromSuperview()
        self.view.setNeedsDisplay()
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
