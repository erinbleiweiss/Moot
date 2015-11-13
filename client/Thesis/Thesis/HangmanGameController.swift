//
//  HangmanGameController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/12/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HangmanGameController {
    var gameView: UIView!
    var level: Level!
    
    init() {
    }
    
    // Get random word from DB
    func getRandomWord(completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/generate_random_word"
        Alamofire.request(.GET, url).responseJSON { (_, _, result) in
    
            let json = JSON(result.value!)
            if let word = json["word"].string{
                completionHandler(responseObject: word, error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Not Found", error: result.error as? NSError)
            }
                
        }
    }
    
}

