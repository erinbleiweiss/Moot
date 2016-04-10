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
import FBSDKCoreKit
import FBSDKShareKit
import SafariServices
import DynamicColor

class GenericLevelViewController: MootViewController, FlipTransitionProtocol, FlipTransitionCVProtocol, SFSafariViewControllerDelegate, UIDocumentInteractionControllerDelegate {

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
    
    var particles: [String] = []
    var pointsShower: EmoticonParticleView!
    
    var docController = UIDocumentInteractionController()
    

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
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.view.backgroundColor = mootBackground
        
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
        if self.displayCamera{
            let tabBar = self.parentViewController?.tabBarController as! MootTabBarController
            tabBar.addCameraButton()
            (self.tabBarController as! MootTabBarController).setupTabColors()
        }
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
    
    func stopPointsShower(){
        UIView.animateWithDuration(
            0.5,
            delay: 2,
            options: [],
            animations: {
                self.pointsShower.alpha = 0
            },
            completion: { (finished: Bool) -> Void in
                self.pointsShower.removeFromSuperview()
                self.particles = []
            })

    }
   
    /**
        Display "stage completed" view then prepare for new level:
            - Clear scanned UPC value and target word
            - Set up level with new word
     */
    func displayStageCompletionView(){
        
        let blurredView = self.view.createBlurredView()
        blurredView.alpha = 0
        self.view.addSubview(blurredView)
        
        let checkmarkView = UIImageView(image: UIImage(named: "checkmark")?.imageWithColor(mootColors["green"]!.saturatedColor()))
        let size = ScreenWidth * 0.75
        let x = (ScreenWidth / 2) - (size / 2)
        let y = (ScreenHeight / 2) - (size / 2)
        checkmarkView.frame = CGRectMake(x, y, size, size)
        checkmarkView.alpha = 0
        self.view.addSubview(checkmarkView)
        
        
        let duration: NSTimeInterval = 0.5

        UIView.animateWithDuration(
            duration,
            delay: 0.5,
            options: [],
            animations: {
                blurredView.alpha = 1
                checkmarkView.alpha = 1
            },
            completion: {(finished: Bool) -> Void in
                self.delay(2){
                    UIView.animateWithDuration(
                        duration,
                        delay: 0,
                        options: [],
                        animations: {
                            blurredView.alpha = 0
                            checkmarkView.alpha = 0
                        },
                        completion: {(finished: Bool) -> Void in
                            blurredView.removeFromSuperview()
                            checkmarkView.removeFromSuperview()
                            self.setUpLevel()
                            if self.controller.level != nil{
                                self.header?.levelBadge!.update(self.controller.level!)
                                self.view.layoutSubviews()
                            }
                    
                    })
                }
            })
        }
    
    
    
    /**
        Transition to the "Level Completed" controller, then prepare for new nevel
     */
    func displayLevelCompletionView(){

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
        let imgURL = AchievementManager.sharedInstance.getLocalImg(title)
        alertView.showTitle(
            title,
            subTitle: description,
            duration: 0.0,
            completeText: "Ok",
            style: .Custom,
            colorStyle: 0x000000,
            colorTextButton: 0xFFFFFF,
            circleIconImage: UIImage(named: imgURL),
            topLabel: "Achievement Unlocked!"
        )
        self.currentAlertView = alertView
        self.achTitle = title
        self.achDesc = description
        self.achImgUrl = AchievementManager.sharedInstance.getImg(title)
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
        self.pointsShower = EmoticonParticleView(frame: self.view.frame, emoticons: self.particles)
        self.view.addSubview(pointsShower)
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
        self.stopPointsShower()
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
            let content = FBSDKShareLinkContent()
            content.contentURL = NSURL(string: "http://www.erinbleiweiss.com/moot")
            content.imageURL = NSURL(string: self.achImgUrl!)
            content.contentTitle = self.achTitle!
            content.contentDescription = "I just earned the '\(self.achTitle!)' achievement on Moot"
            
            let dialog: FBSDKShareDialog = FBSDKShareDialog()
            dialog.fromViewController = self
            dialog.shareContent = content
            dialog.mode = .Native
            // if you don't set this before canShow call, canShow would always return YES
            if !dialog.canShow() {
                // fallback presentation when there is no FB app
                dialog.mode = .Browser
            }
            dialog.show()
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    @objc func twitterTapped(btn: UIButton){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let prewrittenTweet = "I just earned the '\(self.achTitle!)' Achievement on Moot http://erinbleiweiss.com/moot"
            // Set the note text as the default post message.
            if prewrittenTweet.characters.count <= 140 {
                tweetShare.setInitialText(prewrittenTweet)
            }
            else {
                let index = prewrittenTweet.startIndex.advancedBy(140)
                let subText = prewrittenTweet.substringToIndex(index)
                tweetShare.setInitialText(subText)
            }
            self.presentViewController(tweetShare, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @objc func instagramTapped(btn: UIButton){
        let image: UIImage = self.getScreenshot()
        let instagramURL = NSURL(string: "instagram://app")
        
        if UIApplication.sharedApplication().canOpenURL(instagramURL!) {
            let imageData = UIImageJPEGRepresentation(image, 100)
            let writePath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("instagram.igo")
            
            guard let _ = imageData?.writeToFile(writePath, atomically: true) else {
                return
            }
            
            let fileURL = NSURL(fileURLWithPath: writePath)
            self.docController.URL = fileURL
            self.docController.delegate = self
            self.docController.UTI = "com.instagram.exclusivegram"
            self.docController.presentOpenInMenuFromRect(CGRectZero, inView: self.view, animated: true)
        }
        else {
            // alert displayed when the instagram application is not available in the device
            UIAlertView(title: "Instagram Not Available", message: "Please install Instagram to share", delegate:nil, cancelButtonTitle:"Ok").show()
        }
        
    }
    
    
    func getScreenshot() -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0)
        self.view.window?.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
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
