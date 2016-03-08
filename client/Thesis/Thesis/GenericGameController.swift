//
//  GenericGameController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 1/31/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class GenericGameController{
    var gameView: UIView!

    var defaults: NSUserDefaults?
    var username: String?
    var password: String?
//    var headers: [String: String]
    
    init() {
        self.defaults = NSUserDefaults.standardUserDefaults()
        self.username = defaults!.stringForKey("username")
        self.password = defaults!.stringForKey("password")
        
        // Pre-authorize all API Requests with appropriate headers
        let credentialData = "\(self.username!):\(self.password!)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers
    }
    
    func setLevelProgress(level: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(level, forKey: "highest_level")
    }
    
    func getLevelProgress() -> Int{
        let defaults = NSUserDefaults.standardUserDefaults()
        let highestLevel = defaults.integerForKey("highest_level")
        return highestLevel
    }
    
    
    /**
        Convert Postgres timestamps into NSDate Objects, and return as simplified "MM, DD YYYY" string in the user's timezone
     
        - Parameters:
            - jsonDate: (String)
     
        - Returns: A formatted date String
     
    */
    func convertDate(jsonDate: String) -> String{
        let dateFromStringFormatter = NSDateFormatter()
        dateFromStringFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        let date = dateFromStringFormatter.dateFromString(jsonDate) as NSDate!
        
        let stringFromDateFormatter = NSDateFormatter()
        stringFromDateFormatter.timeZone = NSTimeZone.localTimeZone()
        stringFromDateFormatter.dateFormat = "MMMM d, yyyy"
        let dateString = stringFromDateFormatter.stringFromDate(date)
        
        return dateString
    }
    
    
    
    
    /**
        Create a time-stamped entry in the database recording a scanned product for a user.  These entries will be used to track progress towards earning achievements.
     
        - Parameters:
            - username: (String)
            - password: (String)
            - upc: (String) UPC (or ISBN) of the product
            - product_name: (String) Name of the product
            - color: (String) The color of the product
            - type: (String) Used to assign products to special categories used for achievements.  Ex: Food, Books,
     
     
        - Returns: a responseObject (JSON) containing a success code
        {
            status: "success"
        }
     
     
    */
    func saveProduct(upc: String, product_name: String, color: String, type: String, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        
        let url: String = hostname + rest_prefix + "/save_product"
        
        let credentialData = "\(self.username):\(self.password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(.POST, url, parameters: nil, encoding: .JSON, headers: headers)
            .responseJSON { (_, _, result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    print(json["status"])
                    
                    completionHandler(responseObject: json, error: result.error as? NSError)
                case .Failure(_):
                    NSLog("Request failed with error: \(result.error)")
                }
        }
    }
    
    
    
    
}