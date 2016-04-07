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
    let scale: CGFloat = ScreenWidth / 320

    let controller: AchievementDataController
    required init?(coder aDecoder: NSCoder) {
        controller = AchievementDataController()
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set top constraint
        let headerHeight = ScreenHeight * 0.15
        let tabBarHeight = (self.tabBarController?.tabBar.frame.height)!
        let tableViewHeight = ScreenHeight - headerHeight - tabBarHeight
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: headerHeight).active = true
        NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: tableViewHeight).active = true
        
        tableView.delegate = self
        tableView.dataSource = self

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let header = UIView(frame: CGRectMake(0, 0, ScreenWidth, headerHeight))
        header.backgroundColor = mootBlack
        self.view.addSubview(header)
        
        let headerLabel = UILabel(frame: header.frame)
        headerLabel.text = "Achievements"
        headerLabel.font = Raleway.Regular.withSize(30 * scale)
        headerLabel.textAlignment = .Center
        headerLabel.textColor = UIColor.whiteColor()
        header.addSubview(headerLabel)
        
        
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cellHeight = (4 * AchievementTableViewCell().cellMargin) + AchievementTableViewCell().kDescriptionSize + AchievementTableViewCell().kTitleSize + AchievementTableViewCell().kDateSize
        
        return cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("AchievementCell", forIndexPath: indexPath) as! AchievementTableViewCell
        
        if ((indexPath.row % 2) == 0) {
            cell.backgroundColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = mootBackground
        }
        
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
        
//        cell.achievementNameLabel.sizeLabel()
//        cell.achievementDescriptionLabel.sizeLabel()
//        cell.achievementDateLabel.sizeLabel()
        
        
        
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
