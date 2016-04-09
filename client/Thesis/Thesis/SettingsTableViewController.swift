//
//  SettingsTableViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/6/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var storedName: String!
    var nameCell: UITableViewCell = UITableViewCell()
    var nameText: UITextField = UITextField()
    
    var buttonCell: UITableViewCell = UITableViewCell()
    var saveButton: UIButton = UIButton()
    var cancelButton: UIButton = UIButton()
    
    let controller: SettingsDataController
    required init?(coder aDecoder: NSCoder) {
        controller = SettingsDataController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = mootBackground
        
        self.nameCell.backgroundColor = UIColor.whiteColor()
        self.nameText = UITextField(frame: CGRectInset(self.nameCell.contentView.bounds, 15, 0))
        
        self.controller.getName { (responseObject, error) in
            self.storedName = responseObject!["name"].string!
            self.nameText.text = self.storedName
        }
        self.nameCell.addSubview(self.nameText)
        
        self.buttonCell.backgroundColor = UIColor.whiteColor()
        let buttonWidth = ScreenWidth / 4
        let buttonHeight = self.buttonCell.bounds.height * 0.7
        let leftAlignX = ScreenWidth * 0.15
        let rightAlignX = ScreenWidth * 0.60
        let alignY = self.buttonCell.bounds.height * 0.15
        
        self.cancelButton = UIButton(frame: CGRectMake(leftAlignX, alignY, buttonWidth, buttonHeight))
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.layer.cornerRadius = 2
        self.cancelButton.layer.borderColor = mootColors["red"]!.CGColor
        self.cancelButton.titleLabel?.textColor = mootColors["red"]!
        self.cancelButton.setAttributedTitle(NSAttributedString(string: "Cancel"), forState: .Normal)
        self.cancelButton.addTarget(self, action:#selector(self.cancelButtonPressed), forControlEvents: .TouchUpInside)
        
        self.saveButton = UIButton(frame: CGRectMake(rightAlignX, alignY, buttonWidth, buttonHeight))
        self.saveButton.layer.borderWidth = 1
        self.saveButton.layer.cornerRadius = 2
        self.saveButton.layer.borderColor = mootColors["blue"]!.CGColor
        self.saveButton.titleLabel?.textColor = mootColors["blue"]!
        self.saveButton.setAttributedTitle(NSAttributedString(string: "Save"), forState: .Normal)
        self.saveButton.addTarget(self, action:#selector(self.saveButtonPressed), forControlEvents: .TouchUpInside)

        
        self.buttonCell.addSubview(self.saveButton)
        self.buttonCell.addSubview(self.cancelButton)
    }


    func cancelButtonPressed(sender: UIButton){
        self.nameText.text = self.storedName
    }
    
    func saveButtonPressed(sender: UIButton){
        self.controller.editName(self.nameText.text!){ responseObject, error in
            if responseObject!["status"] == "success"{
                self.storedName = responseObject!["name"].string
                self.nameCell.accessoryType = .Checkmark
                
                self.delay(3.0){
                    self.nameCell.accessoryType = .None
                }
                
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch(indexPath.section){
            case 0:
                switch(indexPath.row){
                    case 0: return self.nameCell
                    default: fatalError("Unknown row in section")
                }
            case 1:
                switch(indexPath.row){
                    case 0: return self.buttonCell
                    default: fatalError("Unknown row in section")
                }
            default: fatalError("Unknown section")
            
        }
        
    }


    /**
         Wrapper around Apple's dispatch_after() function in order to execute a code
         block after a specified amount of time
         
         - Parameters:
         - delay: (Double) time in seconds
         
         - Returns: none
     
     */
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    
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
