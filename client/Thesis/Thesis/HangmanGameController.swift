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
import SwiftyJSON

class HangmanGameController: GenericGameController {
    var gameView: UIView!
    
    var upc: String = ""
    var productName: String = ""
    var targetWord: String = ""
    var currentGuess: String = ""
    var currentGame: String = ""
    var guess: String!
    
    
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
    
    
    func playHangman(upc: String, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/play_hangman"
        Alamofire.request(.GET, url, parameters: ["upc": upc, "target_word": targetWord, "letters_guessed": currentGame]).responseJSON { (_, _, result) in
            
            let json = JSON(result.value!)
            completionHandler(responseObject: json, error: result.error as? NSError)
            
//            if(error == nil) {
//                NSLog("Success: \(url)")
//                var json = JSON(result.value)
//                completionHandler(responseObject: {"result": "Not Found"}, error: result.error as? NSError)
//
//            }
//            else {
//                NSLog("Error: \(error)")
//                print(result)
//                completionHandler(responseObject: json, error: result.error as? NSError)
//            }
            
        }
        
    }
    
    

    
    
    
}

