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
    
    /// Get random word from DB
    func getRandomWord(completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/generate_random_word"
        Alamofire.request(.GET, url).responseJSON { (_, _, result) in
    
            let json = JSON(result.value!)
            if let word = json["word"].string{
                print(word)
                completionHandler(responseObject: word, error: result.error as? NSError)
            } else {
                // There was a problem retrieving a word from the database
                completionHandler(responseObject: "Not Found", error: result.error as? NSError)
            }
                
        }
    }
    
    
    /** 
        Using the letter from the most recently scanned UPC, verify whether the
        guessed letter is in the target word. 
    
        - Parameters: 
            - upc: (String) barcode of scanned product
    
        - Returns: a responseObject (JSON), containing the letters in the 
        current game, in the form 
        {
            guess: "S"
            status: 1
            letters_guessed: "STR_NG"
        }
    
        - status return codes:
            - 0: Letter already in word
            - 1: Correct guess
            - 2: Incorrect guess
    
    */
    func playHangman(upc: String, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/play_hangman"
        Alamofire.request(.GET, url, parameters: ["upc": upc, "target_word": targetWord, "letters_guessed": currentGame]).responseJSON { (_, _, result) in
            
            switch result {
                case .Success(let data):
                    let json = JSON(data)
                    // let lettersGuessed = json["letters_guessed"].stringValue
                    completionHandler(responseObject: json, error: result.error as? NSError)
                case .Failure(_, let error):
                    NSLog("Request failed with error: \(error)")
            }
            
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

