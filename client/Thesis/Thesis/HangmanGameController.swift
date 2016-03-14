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
    func getRandomWord(completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/generate_random_word"
        Alamofire.request(.GET, url, parameters: ["difficulty": self.level!.getCurrentStage()]).responseJSON { (_, _, result) in
            switch result {
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    let word = json["word"].stringValue
                    print(word)
                    self.targetWord = word
                    self.currentGame = ""
                    completionHandler(responseObject: word, error: result.error as? NSError)
                case .Failure(_):
                    // There was a problem retrieving a word from the database
                    NSLog("getRandomWord failed with error: \(result.error)")
                    completionHandler(responseObject: "Request failed with error: \(result.error)", error: result.error as? NSError)
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
        Alamofire.request(.GET, url, parameters: ["upc": upc, "target_word": targetWord, "letters_guessed": currentGame]).responseJSON { (_, _, result) in
            
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
                    let achievements_earned = json["achievements_earned"]
                    self.displayAchievements(achievements_earned)
                    self.checkForSuccess()
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
                // Stage is not complete
                return 1
            }
        }
        // Stage is complete, check for level completion
        let level_complete = self.checkLevelCompleted()
        if (!level_complete){
            advanceStage() // Not final stage; Level not complete
            return 1
        } else {
            succeed() // Final stage; Level is complete
            return 2
        }
        
    }
    
    func advanceStage(){
        
        print("pressed")
//        self.level?.advanceToNextStage()
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let successVC = storyboard.instantiateViewControllerWithIdentifier("StageCompleteVC")
//        let rootVC = level?.getRootVC()
//        
//        let rootVC = level?.getRootVC() as! UINavigationController
//        let rootVC = self.gameView.window!.rootViewController as! LoginViewController
//        let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
//        rootVC!.presentViewController(successVC, animated: true, completion: nil)

//        rootVC.showViewController(successVC, sender: nil)
        
//        rootVC.performSegueWithIdentifier("HangmanSuccess", sender: rootVC)
        
    }
    

    
    
    
}

