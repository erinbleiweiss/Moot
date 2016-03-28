//
//  GenericLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/24/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import SwiftHEXColors

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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
