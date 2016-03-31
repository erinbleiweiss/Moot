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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    
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
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("HighScoreCell", forIndexPath: indexPath) as! UITableViewCell
        
        return cell
    }
    
    

}
