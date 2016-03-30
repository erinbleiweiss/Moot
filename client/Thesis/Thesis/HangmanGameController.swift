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
    var loading: Bool = false;
    
    /// Array containing tile objects, each containing a letter
    var gameTiles = [HangmanTile]()
    
    /**
        Generate a random word via the Wordnik API, and set up constants for game
        
        - Parameters: none
    
        - Returns: a responseObject (JSON), containing the target word for the current game
        { word: "randomword" }
    
    */
    func getRandomWord(completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/generate_random_word"
        let difficulty = self.getCurrentStage()
     
        Alamofire.request(.GET, url, parameters: ["difficulty": difficulty], headers: headers).responseJSON { (_, _, result) in
          switch result {
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    let word = json["word"].stringValue
                    print(word)
                    self.targetWord = word
                    self.currentGame = ""

                    completionHandler(responseObject: json, error: result.error as? NSError)
                case .Failure(_):
                    // There was a problem retrieving a word from the database
                    NSLog("getRandomWord failed with error: \(result.error)")
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
        self.loading = true;
        let url: String = hostname + rest_prefix + "/play_hangman"
        Alamofire.request(.GET, url, parameters: ["upc": upc, "target_word": targetWord, "letters_guessed": currentGame], headers: headers).responseJSON { (_, _, result) in
            
            switch result {
                case .Success(let data):
                    let json = JSON(data)
                    // Update state of current game
                    self.currentGuess = json["guess"].stringValue
                    let game_state = json["letters_guessed"].stringValue
                    self.currentGame = game_state
                    for (index, letter) in game_state.characters.enumerate() {
                        self.gameTiles[index].updateLetter(letter)
                    }
                    completionHandler(responseObject: json, error: result.error as? NSError)
                case .Failure(_):
                    NSLog("Request failed with error: \(result.error)")
            }
            
        }
        
    }
    
    /** 
        Called after each "move" to determine whether the game is complete (all tiles are filled)
        
        - Parameters: none
        - Returns: a return code indicating the appropriate behavior
            - 0: Current stage is not complete, take no action
            - 1: Current stage is complete, and level should advance to next stage
            - 2: Current stage is complete, and is the final stage in the level.  Should complete and advance to next level.
            - 3: Default return code (Something unexpected happened)
    
    */
    func checkForSuccess() -> Int{
        
        for tile in gameTiles{
            if !tile.isFilled{
                return 0 // Stage is not complete
            }
        }
        // Stage is complete, check for level completion
        let level_complete = self.checkLevelCompleted()
        if (!level_complete){
          self.advanceToNextStage()
          self.upc = ""
          self.targetWord = ""
          self.clearTiles()
          return 1 // Not final stage; Level not complete
        } else {
          self.upc = ""
          self.succeed() // Final stage; Level is complete
          return 2
        }
        
    }
    

    /**
        To be called between levels:
            - remove all tiles from view
            - clear gameTiles array
     */
    func clearTiles(){
        for tile in self.gameTiles {
            tile.removeFromSuperview()
        }
        self.gameTiles.removeAll()
    }
    
    
}

