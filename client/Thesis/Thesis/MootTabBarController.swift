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
    var button: CameraTabButton?
    var selectedButtonColor: UIColor?
    
    var originalImages: [UIImage] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()

//        // turn off top border
//        self.tabBar.barStyle = UIBarStyle.Black
        self.tabBar.translucent = false

        let color = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = color
        
        for item in self.tabBar.items! as! [RAMAnimatedTabBarItem]{
            if (item.iconView?.icon.image) != nil{
                self.originalImages.append((item.iconView?.icon.image)!)
            }
        }
        
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable middle tab bar item
        if  let arrayOfTabBarItems = self.tabBar.items as! AnyObject as? NSArray,tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
            tabBarItem.enabled = false
        }
        
        changeButtonColor(mootBlack)
        
        self.setupTabColors()
    }
    
    public override func viewDidLayoutSubviews() {
        self.setupTabColors()
    }
    
    
    func setupTabColors(){
        var iconColor: UIColor?
        if self.selectedButtonColor != nil {
            iconColor = self.selectedButtonColor
        }
        else {
            iconColor = mootBlack
        }

        let selectedItem = self.tabBar.selectedItem
        if selectedItem != nil {
            let image = (selectedItem! as UITabBarItem).selectedImage
            (selectedItem as! RAMAnimatedTabBarItem).iconView?.textLabel.textColor = iconColor!
            (selectedItem as! RAMAnimatedTabBarItem).iconView!.icon.image = image!.imageWithColor(iconColor!).imageWithRenderingMode(.AlwaysOriginal)
        }
        
        for (idx, item) in (self.tabBar.items! as! [RAMAnimatedTabBarItem]).enumerate(){
            if item != selectedItem{
                item.iconView?.textLabel.textColor = mootBlack
                let newImage = self.originalImages[idx].imageWithColor(mootBlack).imageWithRenderingMode(.AlwaysOriginal)
                item.iconView?.icon.image = newImage
            }
        }
        
        for item in self.tabBar.items!{
            item.setTitleTextAttributes([NSForegroundColorAttributeName: iconColor!], forState: .Normal)
            item.setTitleTextAttributes([NSForegroundColorAttributeName: iconColor!], forState: .Selected)
        }
        
        self.view.setNeedsDisplay()
    }
    
    func triggerUpdate(){
        self.setupTabColors()
    }
    
    public func createRaisedButton(buttonImage: UIImage?, highlightImage: UIImage?) {
        if let buttonImage = buttonImage {
            self.button = CameraTabButton(type: UIButtonType.Custom)
            self.button!.tag = 1337
            self.button!.autoresizingMask = [UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin]
            
            let buttonSize = self.tabBar.frame.height * 1.5
            self.button!.frame = CGRectMake(0.0, 0.0, buttonSize, buttonSize)


            let imageOffsetY: CGFloat = buttonSize * 0.05
            let imageFrame = CGRectMake(0, -imageOffsetY, buttonSize, buttonSize)
            self.button!.setImage(buttonImage, inFrame: imageFrame, forState: UIControlState.Normal)
            self.button!.setImage(buttonImage, inFrame: imageFrame, forState: UIControlState.Highlighted)
            
            let heightDifference = buttonImage.size.height - self.tabBar.frame.size.height
            
            if (heightDifference < 0) {
                self.button!.center = self.tabBar.center
            }
            else {
                var center = self.tabBar.center
                center.y -= heightDifference / 2.0
                
                self.button!.center = center
            }
            
            self.button!.addTarget(self, action: #selector(MootTabBarController.onRaisedButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.button!.animation = "squeezeUp"
            self.button!.force = 0.5
            self.button!.animate()
            self.view.addSubview(button!)
        }
    }
    
    public func onRaisedButton(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let modalVC = storyboard.instantiateViewControllerWithIdentifier(self.cameraVC!) as UIViewController
        self.selectedViewController?.presentViewController(modalVC, animated: true, completion: { () -> Void in  
            
        })
        
    

    }
    
    public func changeButtonColor(color: UIColor){
        self.selectedButtonColor = color
    }
    

    public func addCameraButton(){
        if !cameraButtonVisible{
            // Raise the center button with image
            let img = UIImage(named: "camera")!.imageWithColor(mootBlack)
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
    
    func getScreenshot() -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func fadeViewForTransition(transition: FadeTransition) -> UIView? {
        return self.view
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
