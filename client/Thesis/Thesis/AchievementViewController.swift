//
//  AchievementViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/4/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class AchievementViewController: MootViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let controller: AchievementDataController
    required init?(coder aDecoder: NSCoder) {
        controller = AchievementDataController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gameView = UIView(frame: CGRectMake(0, -200, ScreenWidth, ScreenHeight))
        self.view.addSubview(gameView)
        self.controller.gameView = gameView
        
        tableView.delegate = self
        tableView.dataSource = self

        
        let defaults = NSUserDefaults.standardUserDefaults()

        self.controller.getAchievements(){ responseObject, error in
            self.tableView.reloadData()
        }
        self.controller.getUnearnedAchievements(){ responseObject, error in
            self.tableView.reloadData()
        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.controller.allAchievements.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("AchievementCell", forIndexPath: indexPath) as! AchievementTableViewCell
        
        let achievement = self.controller.allAchievements[indexPath.row]
        if achievement.isEarned(){
            cell.achievementImage.image = UIImage(named: "medal")
            cell.achievementNameLabel.text = achievement.getName()
            cell.achievementDescriptionLabel.text = achievement.getDescription()
            cell.achievementDateLabel.text = "Earned " + achievement.getDate()
        } else {
            cell.achievementImage.image = UIImage(named: "locked")
            cell.achievementNameLabel.text = achievement.getName()
            cell.achievementNameLabel.textColor = UIColor.grayColor()
            cell.achievementDescriptionLabel.text = achievement.getDescription()
            cell.achievementDescriptionLabel.textColor = UIColor.grayColor()
            cell.achievementDateLabel.text = "Locked"
            cell.achievementDateLabel.textColor = UIColor.grayColor()
        }
        
        
        return cell
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
