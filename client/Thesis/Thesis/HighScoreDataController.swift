//
//  HighScoreGameController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/31/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class HighScoreDataController: GenericGameController{

    var highScores: [Score] = []
    let num_scores_to_retrieve = 0 // If this value is 0, all scores will be retrieved
    
    let score_limit = 10
    var is_top_scorer = false
    
    func getHighScores(completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/get_high_scores"
        Alamofire.request(.GET, url, parameters: ["num_scores": num_scores_to_retrieve])
            .responseJSON { (_, _, result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    
                    for (item, subJson):(String, JSON) in json{
                        if (item == "scores"){
                            self.createScores(subJson)
                        }
                    }
                    completionHandler(responseObject: json, error: result.error as? NSError)
                case .Failure(_):
                    NSLog("Request failed with error: \(result.error)")
                }
        }
    }
    
    func createScores(scores: JSON){
        highScores = []
        for (_, subJson):(String, JSON) in scores {
            var name = subJson["name"].string
            let score = subJson["score"].int!
            // TODO: crashes if nil
            
            if name == nil || name == ""{
                name = "A Moot User"
            }
            
            let uuid = subJson["uuid"].string
            
            let rank = subJson["rank"].int!
            
            if self.highScores.count < score_limit {
                highScores.append(Score(name: name!, score: score, uuid: uuid!, rank: rank))
                if uuid == get_uuid() {
                    self.is_top_scorer = true
                }
            } else if (uuid == get_uuid()) && !is_top_scorer{
                highScores.append(Score(name: name!, score: score, uuid: uuid!, rank: rank))
            }
        
        }
    }
    
    

}