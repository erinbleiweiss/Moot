//
//  AchievementTableViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/28/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AchievementTableViewController: UITableViewController {

    var allAchievements: [Achievement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "menu"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        //        btnName.addTarget(self, action: Selector("action"), forControlEvents: .TouchUpInside)
        
        
        if self.revealViewController() != nil {
            btnName.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: .TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //.... Set Left Bar Button item
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let username = defaults.stringForKey("username")
        {
            let password = defaults.stringForKey("password")
            self.getAchievements(username, password: password!){ responseObject, error in
                
            }
            self.getUnearnedAchievements(username, password: password!){ responseObject, error in
                
            }
        
        }
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.allAchievements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AchievementCell", forIndexPath: indexPath) as! AchievementTableViewCell
        
        // Configure the cell...
//        if indexPath.row == 0 {
//            cell.achievementImage.image = UIImage(named: "medal")
//            cell.achievementNameLabel.text = "My First Achievement"
//            cell.achievementDescriptionLabel.text = "This is the first achievement that you will earn in the game. This description has a clever tagline explaining more"
//            cell.achievementDateLabel.text = "Earned 2/2/2016"
//        } else {
//            cell.achievementImage.image = UIImage(named: "medal")
//            cell.achievementNameLabel.text = "My First Achievement"
//            cell.achievementDescriptionLabel.text = "This is the first achievement that you will earn in the game. This description has a clever tagline explaining more"
//            cell.achievementDateLabel.text = "Earned 2/2/2016"
//        }
        
        let achievement = self.allAchievements[indexPath.row]
        cell.achievementImage.image = UIImage(named: "medal")
        cell.achievementNameLabel.text = achievement.getName()
        cell.achievementDescriptionLabel.text = achievement.getDescription()
        cell.achievementDateLabel.text = "Earned 2/2/2016"
    
        return cell
    }
    
    
    func getAchievements(user: String, password: String, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        
        let url: String = hostname + rest_prefix + "/get_achievements"
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON, headers: headers)
            .responseJSON { (_, _, result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    print(json["status"])
                    
                    for (item, subJson):(String, JSON) in json{
                        if (item == "achievements"){
                            print(subJson)
                            self.createAchievements(subJson)
                        }
                    }
                    completionHandler(responseObject: json, error: result.error as? NSError)
                case .Failure(_):
                    NSLog("Request failed with error: \(result.error)")
                }
        }
    }
    
    
    func getUnearnedAchievements(user: String, password: String, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        
        let url: String = hostname + rest_prefix + "/get_unearned_achievements"
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON, headers: headers)
            .responseJSON { (_, _, result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    print(json["status"])
                    
                    for (item, subJson):(String, JSON) in json{
                        if (item == "achievements"){
                            print(subJson)
                            self.createUnearnedAchievements(subJson)
                        }
                    }
                    completionHandler(responseObject: json, error: result.error as? NSError)
                case .Failure(_):
                    NSLog("Request failed with error: \(result.error)")
                }
        }
    }
    
    
    
    func createAchievements(achievements: JSON){
        for (_, subJson):(String, JSON) in achievements {
            let name = subJson["name"].string
            let description = subJson["description"].string
            let new_ach = Achievement(name: name!, description: description!)
            allAchievements.append(new_ach)
        }
//        self.tableView.reloadData()
    }
    
    func createUnearnedAchievements(achievements: JSON){
        for (_, subJson):(String, JSON) in achievements {
            let name = subJson["name"].string
            let description = subJson["description"].string
            let new_ach = Achievement(name: name!, description: description!)
            allAchievements.append(new_ach)
        }
        self.tableView.reloadData()
    }
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
