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
    
    var upc: String = ""
    var productName: String = ""
    var targetWord: String = ""
    var currentGuess: String = ""
    var currentGame: String = ""
    var guess: String!
    
    /// Array containing tile objects, each containing a letter
    var gameTiles = [HangmanTile]()
    
    // Get random word from DB
    func getRandomWord(completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/generate_random_word"
        Alamofire.request(.GET, url).responseJSON { (_, _, result) in
    
            let json = JSON(result.value!)
            if let word = json["word"].string{
                print(word)
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
    
    /// Called after each "move" to determine whether the game is complete (all tiles are filled)
    func checkForSuccess() -> Bool{
        print("checking for success")
        for tile in gameTiles{
            if !tile.isFilled{
                print("no")
                return false
            }
        }
        print("yes")
        return true
    }


    
    
    
}

