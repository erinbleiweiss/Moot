//
//  HighScoreViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/31/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class HighScoreViewController: MootViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let scale: CGFloat = ScreenWidth / 320

    let controller: HighScoreDataController
    required init?(coder aDecoder: NSCoder) {
        controller = HighScoreDataController()
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

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        let header = UIView(frame: CGRectMake(0, 0, ScreenWidth, headerHeight))
        header.backgroundColor = mootBlack
        self.view.addSubview(header)
        
        let headerLabel = UILabel(frame: header.frame)
        headerLabel.text = "High Scores"
        headerLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30 * scale)
        headerLabel.textAlignment = .Center
        headerLabel.textColor = UIColor.whiteColor()
        header.addSubview(headerLabel)
        
        self.controller.getHighScores(){ responseObject, error in
            self.tableView.reloadData()
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.controller.highScores.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50 * scale
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("HighScoreCell", forIndexPath: indexPath) as! ScoreTableViewCell
        
        if ((indexPath.row % 2) == 0) {
            cell.backgroundColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = mootBackground
        }
        
        let scoreInfo = self.controller.highScores[indexPath.row]

        cell.numberLabel.text = ("\(scoreInfo.getRank()).")
        cell.nameLabel.text = (scoreInfo.getName())
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        cell.scoreLabel.text = (numberFormatter.stringFromNumber(scoreInfo.getScore())!)
        
        if scoreInfo.isCurrentUser(){
            cell.nameLabel.textColor = mootColors["blue"]
            cell.scoreLabel.textColor = mootColors["blue"]
            cell.numberLabel.textColor = mootColors["blue"]
        } else {
            cell.nameLabel.textColor = UIColor.blackColor()
            cell.scoreLabel.textColor = UIColor.blackColor()
            cell.numberLabel.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    

}
