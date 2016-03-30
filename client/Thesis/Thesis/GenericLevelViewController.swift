//
//  GenericLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/24/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import SwiftHEXColors
import SCLAlertView
import Social

class GenericLevelViewController: MootViewController, FlipTransitionProtocol, FlipTransitionCVProtocol {

    var header: MootHeader?
    
    private var controller: GenericGameController
    required init?(coder aDecoder: NSCoder) {
        controller = GenericGameController()
        super.init(coder: aDecoder)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayCamera = true
        self.showTestPopup()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // Header should start off-screen for animation
        // Y value should be inverse of height
        header = MootHeader(frame: CGRect(x: 0, y: -yOffset, width: ScreenWidth, height: yOffset))
        self.view.addSubview(header!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tabBar = self.parentViewController?.tabBarController as! MootTabBarController
        tabBar.addCameraButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.header?.levelBadge!.update()
    }

    func addHeader(){
        let height = self.header!.frame.height
        self.header?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
    }
    
    func setCameraButton(levelNum: Int){
        let level = LevelManager.sharedInstance.listLevels()[levelNum - 1]
        let vc = level.getCameraVC()
        let tabBar = self.parentViewController?.tabBarController as! MootTabBarController
        tabBar.setCameraVCForButton(vc)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func provideVCClass() -> UIViewController.Type {
        return GenericLevelViewController.self
    }
    
    
    /**
        This method should be overridden in subclasses to perform any "reset" actions if necessary
     */
    func setUpLevel(){
        
    }
    
    
    /**
        Update Moot Points badge with point total from DB, and save score to ScoreManager
     */
    func updateMootPoints(){
        self.controller.getMootPoints { (responseObject, error) -> () in
            if responseObject!["status"] == "success" {
                let points = responseObject!["points"].intValue
                ScoreManager.sharedInstance.setScore(points)
                self.header!.scoreBox?.setPoints(points)
                self.header!.scoreBox?.setNeedsDisplay()
            }
        }
    }
   
    /**
        Transition to the "Stage completed" controller, then prepare for new level:
            - Clear scanned UPC value and target word
            - Set up level with new word
     
        Note that a segue must be created in the storyboard from the level's root navigation controller to the "Stage Complete" view controller
     */
    func displayStageCompletionView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let successVC = storyboard.instantiateViewControllerWithIdentifier("StageCompleteVC")
        self.presentViewController(successVC, animated: false, completion: nil)
        self.setUpLevel()
    }
    
    
    
    /**
        Transition to the "Level Completed" controller, then prepare for new nevel
     */
    func displayLevelCompletionView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let successVC = storyboard.instantiateViewControllerWithIdentifier("LevelCompleteVC")
        self.presentViewController(successVC, animated: false, completion: nil)
        self.setUpLevel()
    }
    
    
    func flipViewForTransition(transition: FlipTransition) -> UIView? {
        return self.view
    }
    
    
    
    func transitionCollectionView() -> UICollectionView! {
        let vc = self.navigationController?.viewControllers[0] as! LevelPickerViewController
        return vc.levelCollectionView
    }
    
    func getSelectedCell() -> LevelCell! {
        let vc = self.navigationController?.viewControllers[0] as! LevelPickerViewController
        return vc.levelCollectionView.cellForItemAtIndexPath(vc.selectedIndexPath!) as! LevelCell
    }
    
    
    
    
    
    
    
    
    /**
     Determine whether an achievement was earned, and if so, display the appropriate popup message
     
     - Parameters:
     - achievements_earned: (JSON) A JSON object from the level's game controller containing a list of all achievements earned
     
     */
    func displayAchievements(acheivements_earned: JSON){
        if (acheivements_earned.count == 0) {
            NSLog("No achievements earned")
        } else {
            for ach in acheivements_earned.arrayValue {
                NSLog(ach.string!)
                let message = "You just earned the \(ach.string!) achievement!"
                self.showAchievementPopUp(ach.string!, message: message)
            }
        }
    }
    
    
    
    //// ==========================================================
    //// POPUP DISPLAYS:
    //// ==========================================================
    
    
    /**
         Use the SCLAlertView class to display a popup for the given achievements
         
         - Parameters:
         - title: (String) Name of achievement
         - message: (String) Description to be displayed
         - image: (UI Image) Image associated with achievement
     */
    func showAchievementPopUp(title: String, message: String){
        let alertView = SCLAlertView()
        alertView.addSocialMedia()
        alertView.showTitle(
            title,
            subTitle: message,
            duration: 0.0,
            completeText: "Ok",
            style: .Custom,
            colorStyle: 0x000000,
            colorTextButton: 0xFFFFFF,
            circleIconImage: UIImage(named: "medal2"),
            topLabel: "Achievement Unlocked!"
        )
    }
    
    
    /**
         Use the SCLAlertview class to display a popup for each item scanned
         
         - Parameters:
         - productName: (String) Name of product
         - color: (UIColor) Color of scanned product
     
     */
    func showProductPopup(productName: String, color: String, url: String){
        var img = UIImage()
        if let data = NSData(contentsOfURL: NSURL(string: url)!) {
            img = UIImage(data: data)!
        }
        let colorInt = getColorFromName(color)
        let alertView = SCLAlertView()
        alertView.addImage(img)
        alertView.addLowerTitle(productName)
        alertView.showTitle(
            "Product Scanned!",
            subTitle: "",
            style: .Success,
            duration: 0.0,
            colorStyle: colorInt,
            colorTextButton: 0xFFFFFF,
            circleIconImage: UIImage(named: "camera")?.imageWithColor(UIColor.whiteColor())
        )
    }
    
    
    /**
         Helper function for use in product popup.  Get color of scanned product from name.
         
         - Parameters:
         - color_name: (String) Name of color
         - Returns: UInt representing color in hex
     
     */
    func getColorFromName(color_name: String) -> UInt{
        let colors: [String: UIColor] = [
            "red":          UIColor(red:0.718,   green: 0.196, blue:0.2,     alpha:1),
            "orange":       UIColor(red:0.937,   green: 0.498, blue:0.00392, alpha:1),
            "yellow":       UIColor(red:0.988,   green: 0.792, blue:0.31,    alpha:1),
            "greenyellow":  UIColor(red:0.784,   green: 0.824, blue:0.098,   alpha:1),
            "green":        UIColor(red:0.545,   green: 0.643, blue:0.0314,  alpha:1),
            "teal":         UIColor(red:0.00392, green: 0.533, blue:0.518,   alpha:1),
            "blue":         UIColor(red:0,       green: 0.447, blue:0.725,   alpha:1),
            "purple":       UIColor(red:0.627,   green: 0.333, blue:0.596,   alpha:1)
        ]
        
        let color: UIColor = colors[color_name]!
        let colorHex = color.toHexString()
        let colorInt = UInt(colorHex, radix: 16)
        return colorInt!
    }
    
    
    
    func showTestPopup(){
        
        let alertView = SCLAlertView()
        let btns: [UIButton] = alertView.addSocialMedia()
        self.addSocialMediaTargets(btns)
        alertView.showTitle(
            "Alert",
            subTitle: "This is an alert.",
            style: .Success)
        
    }
    
    
    /**
        Add targets for scocial media button actions.  This should contain a string array "platforms" which defines each social media button.  For each platform, there should be a corresponding selector function in this class to handle the button press action.
     
        - Parameters: btns: [UIButton] - returned from SCLAlertView().addSocialMedia()
     
     */
    func addSocialMediaTargets(btns: [UIButton]){
        let platforms = ["facebook", "twitter", "googleplus", "instagram"]
        for (idx, btn) in btns.enumerate() {
            btn.addTarget(self, action: Selector("\(platforms[idx])Tapped:"), forControlEvents: .TouchUpInside)
        }
    }
    

    
    /**
        The following selector functions handle button taps from SCLAlertView social media button presses
     */
    @objc func facebookTapped(btn: UIButton){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @objc func twitterTapped(btn: UIButton){
        print("my custom twitter button tapped")
    }
    
    @objc func googleplusTapped(btn: UIButton){
        print("my custom google plus button tapped")
    }
    
    @objc func instagramTapped(btn: UIButton){
        print("my custom instagram button tapped")
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
