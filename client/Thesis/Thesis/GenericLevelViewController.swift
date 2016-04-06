//
//  GenericLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/24/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import SwiftHEXColors
import SwiftyJSON
import SCLAlertView
import Social
import FBSDKShareKit

class GenericLevelViewController: MootViewController, FlipTransitionProtocol, FlipTransitionCVProtocol, FBSDKSharingDelegate {

    var header: MootHeader?
    var currentAlertView: SCLAlertView?
    
    var visibleWidth = ScreenWidth
    var visibleHeight = ScreenHeight - yOffset
    var navBarHeight = yOffset
    var tabBarHeight: CGFloat?
    
    // Data for achievement popups
    var achTitle: String?
    var achDesc: String?
    var achImgUrl: String?
    
    var shouldDisplayStageCompleted: Bool = false
    var shouldDisplayLevelCompleted: Bool = false
    
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
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        // Header should start off-screen for animation
        // Y value should be inverse of height
        header = MootHeader(frame: CGRect(x: 0, y: -yOffset, width: ScreenWidth, height: yOffset))
        self.view.addSubview(header!)
        
        self.header!.resetButton!.addTarget(self, action: #selector(self.resetButtonTouched(_:)), forControlEvents: .TouchUpInside)
        let buttonItem = UIBarButtonItem(customView: self.header!.resetButton!)
        self.navigationItem.rightBarButtonItem = buttonItem
        
        self.tabBarHeight = (self.parentViewController?.tabBarController!.tabBar.frame.height)! + 25.0
        self.visibleHeight -= tabBarHeight!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tabBar = self.parentViewController?.tabBarController as! MootTabBarController
        tabBar.addCameraButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    @objc func resetButtonTouched(btn: UIButton) {
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
        if self.controller.level != nil {
            self.header?.levelBadge!.update(self.controller.level!)
        }
    }
    
    
    
    /**
        Transition to the "Level Completed" controller, then prepare for new nevel
     */
    func displayLevelCompletionView(){
        print("alright alright alright alright")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let successVC = storyboard.instantiateViewControllerWithIdentifier("LevelCompleteVC")
//        self.presentViewController(successVC, animated: false, completion: nil)

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
        Determine whether an achievement was earned, using checkForAchievements() call from game controller, and if so, display the appropriate popup message
     
     */
    func displayAchievements(){
        self.controller.checkForAchievements({ (responseObject, error) in
            if responseObject!["status"] == "success" {
                let achievements = responseObject!["achievements"]
                
                if achievements.count == 0 {
                    self.doAfterAchievementPopup()
                } else {
                    for ach in achievements {
                        let achievementTitle = ach.1["name"].string
                        let description = ach.1["description"].string
                        self.showAchievementPopUp(achievementTitle!, description: description!)
                    }
                }

            }
            
        })
        
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
    func showAchievementPopUp(title: String, description: String){
        let alertView = SCLAlertView()
        let btns: [UIButton] = alertView.addSocialMedia()
        self.addSocialMediaTargets(btns)
        alertView.showCloseButton = false
        alertView.addButton("Done") {
            self.doAfterAchievementPopup()
        }
        alertView.showTitle(
            title,
            subTitle: description,
            duration: 0.0,
            completeText: "Ok",
            style: .Custom,
            colorStyle: 0x000000,
            colorTextButton: 0xFFFFFF,
            circleIconImage: UIImage(named: "medal"),
            topLabel: "Achievement Unlocked!"
        )
        self.currentAlertView = alertView
        self.achTitle = title
        self.achDesc = description
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
        alertView.showCloseButton = false
        alertView.addButton("Done") {
            self.doAfterProductPopup()
        }
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
    
    func doAfterProductPopup(){
        self.displayAchievements()
    }
    
    func doAfterAchievementPopup(){
        if self.shouldDisplayStageCompleted{
            self.shouldDisplayStageCompleted = false
            self.displayStageCompletionView()
        } else if self.shouldDisplayLevelCompleted{
            self.shouldDisplayLevelCompleted = false
            self.displayLevelCompletionView()
        }
    }
    
    
    /**
         Helper function for use in product popup.  Get color of scanned product from name.
         
         - Parameters:
         - color_name: (String) Name of color
         - Returns: UInt representing color in hex
     
     */
    func getColorFromName(color_name: String) -> UInt{
        let color: UIColor = mootColors[color_name]!
        let colorHex = color.toHexString()
        let colorInt = UInt(colorHex, radix: 16)
        return colorInt!
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
            print("alright alright alright alright")
            let fbShare = FBSDKShareDialog()
            fbShare.fromViewController = self
            let content = FBSDKShareLinkContent()
            content.contentURL = NSURL(string: "http://www.erinbleiweiss.com")
            content.imageURL = NSURL(string: "http://i.imgur.com/jUTICVi.png")
            content.contentTitle = "I just earned the \(self.achTitle) achievement"
            content.contentDescription = self.achDesc
            fbShare.shareContent = content
            
//            if UIApplication.sharedApplication().canOpenURL(NSURL(string: "fbauth2://")!) {
//                fbShare.mode = FBSDKShareDialogMode.Native
//            }
//            else {
//                fbShare.mode = FBSDKShareDialogMode.Browser
//                //or FBSDKShareDialogModeAutomatic
//            }
            fbShare.mode = FBSDKShareDialogMode.ShareSheet
            fbShare.delegate = self
            fbShare.show()

            
//            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            self.presentViewController(fbShare, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject: AnyObject]) {
        print(results)
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print("sharer NSError")
        print(error.description)
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        print("sharerDidCancel")
    }
    
    
    @objc func twitterTapped(btn: UIButton){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//            let prewrittenTweet = self.currentAlertView!.labelTitle.text
//            print("Prewritten tweet: \(prewrittenTweet)")
//            // Set the note text as the default post message.
//            if prewrittenTweet?.characters.count <= 140 {
//                tweetShare.setInitialText(prewrittenTweet)
//            }
//            else {
//                let index = prewrittenTweet!.startIndex.advancedBy(140)
//                let subText = prewrittenTweet!.substringToIndex(index)
//                tweetShare.setInitialText(subText)
//            }
            self.presentViewController(tweetShare, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
