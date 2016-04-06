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

        tableView.delegate = self
        tableView.dataSource = self
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("HighScoreCell", forIndexPath: indexPath)
        
        let scoreInfo = self.controller.highScores[indexPath.row]
        let halfWidth = cell.frame.width / 2
        let margin = halfWidth * 0.05
        let indent = 35 * scale
        
        let numberLabelSize = 25 * scale
        let numberLabel = UILabel(frame: CGRectMake(indent, 0, numberLabelSize, cell.frame.height))
        numberLabel.text = "\(indexPath.row + 1))"
        
        
        let nameLabel = UILabel(frame: CGRectMake(numberLabelSize + indent, 0, halfWidth - margin, cell.frame.height))
        nameLabel.textAlignment = .Center
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        let scoreLabel = UILabel(frame: CGRectMake(halfWidth + indent + numberLabelSize, 0, halfWidth - margin, cell.frame.height))
        scoreLabel.textAlignment = .Left
        
        for scoreItem in scoreInfo{
            nameLabel.text = scoreItem.0
            scoreLabel.text = numberFormatter.stringFromNumber((Int(scoreItem.1))!)!
        }
        
        nameLabel.font = UIFont(name: (nameLabel.font?.familyName)!, size: 20 * scale)
        scoreLabel.font = UIFont(name: (scoreLabel.font?.familyName)!, size: 20 * scale)
        numberLabel.font = UIFont(name: (numberLabel.font?.familyName)!, size: 20 * scale)
        
        cell.addSubview(nameLabel)
        cell.addSubview(scoreLabel)
        cell.addSubview(numberLabel)
        
        return cell
    }
    
    

}
