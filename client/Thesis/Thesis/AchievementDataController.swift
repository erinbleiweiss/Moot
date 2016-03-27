//
//  AchievementDataController.swift
//  
//
//  Created by Erin Bleiweiss on 3/3/16.
//
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class AchievementDataController: GenericGameController{

    var allAchievements: [Achievement] = []

    func getAchievements(completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/get_achievements"
        Alamofire.request(.GET, url, parameters: nil, headers: headers, encoding: .JSON)
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
    
    
    func getUnearnedAchievements(completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/get_unearned_achievements"
        Alamofire.request(.GET, url, parameters: nil, headers: headers, encoding: .JSON)
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
            let created_at = subJson["created_at"].string
            let dateString = self.convertDate(created_at!)
            let new_ach = Achievement(name: name!, description: description!, date: dateString, earned: true, visible: true)
            allAchievements.append(new_ach)
        }
    }
    
    func createUnearnedAchievements(achievements: JSON){
        for (_, subJson):(String, JSON) in achievements {
            let name = subJson["name"].string
            let description = subJson["description"].string
            let new_ach = Achievement(name: name!, description: description!, date: "", earned: false, visible: true)
            allAchievements.append(new_ach)
        }
    }
    
  
    
    
}