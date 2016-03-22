//
//  GenericLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/24/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import SwiftHEXColors
import SWRevealViewController

class GenericLevelViewController: MootViewController {

    var scoreBox: ScoreBox?
    var levelBadge: LevelBadge?
    
    private var controller: GenericGameController
    required init?(coder aDecoder: NSCoder) {
        controller = GenericGameController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color: UIColor = UIColor(hexString: "#2ecc71")!
        self.view.backgroundColor = color
        // Do any additional setup after loading the view.
        
        let scoreBoxFrame = CGRect(x: 50, y: 100, width: 100, height: 100)
        self.scoreBox = ScoreBox(frame: scoreBoxFrame)
        self.scoreBox!.backgroundColor = UIColor(white: 1, alpha: 1)
        self.view.addSubview(scoreBox!)
        
        let badgeFrame = CGRect(x: self.view.bounds.width - 150, y: 100, width: 100, height: 100)
        self.levelBadge = LevelBadge(frame: badgeFrame)
        self.levelBadge!.backgroundColor = UIColor(white: 1, alpha: 1)
        self.view.addSubview(levelBadge!)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.levelBadge?.update()
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
                self.scoreBox?.setPoints(points)
                self.scoreBox?.setNeedsDisplay()
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
