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
            print(self.controller.highScores)
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
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("HighScoreCell", forIndexPath: indexPath)
        
        let scoreInfo = self.controller.highScores[indexPath.row]
        let halfWidth = cell.frame.width / 2
        let margin = halfWidth * 0.05
        
        let nameLabel = UILabel(frame: CGRectMake(0, 0, halfWidth - margin, cell.frame.height))
        nameLabel.textAlignment = .Right
        let scoreLabel = UILabel(frame: CGRectMake(halfWidth + margin, 0, halfWidth - margin, cell.frame.height))
        scoreLabel.textAlignment = .Left
        
        for scoreItem in scoreInfo{
            nameLabel.text = "\(scoreItem.0): "
            scoreLabel.text = scoreItem.1
        }
        
        cell.addSubview(nameLabel)
        cell.addSubview(scoreLabel)
        
        return cell
    }
    
    

}
