//
//  HangmanData.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/4/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit

class HangmanData: NSObject, NSCoding{
    
    var targetWord: String
    var currentGuess: String
    var currentGame: String

    init(targetWord: String, currentGuess: String, currentGame: String){
        self.targetWord = targetWord
        self.currentGuess = currentGuess
        self.currentGame = currentGame
    }
    
    convenience override init(){
        self.init(
            targetWord: "",
            currentGuess: "",
            currentGame: ""
        )
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        guard let targetWord = aDecoder.decodeObjectForKey("targetWord") as? String
            else {return nil}
        guard let currentGuess = aDecoder.decodeObjectForKey("currentGuess") as? String
            else {return nil}
        guard let currentGame = aDecoder.decodeObjectForKey("currentGame") as? String
            else {return nil}
        
        self.init(
            targetWord: targetWord,
            currentGuess: currentGuess,
            currentGame: currentGame
        )
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(targetWord, forKey: "targetWord")
        aCoder.encodeObject(currentGuess, forKey: "currentGuess")
        aCoder.encodeObject(currentGame, forKey: "currentGame")

    }
    
    func getTargetWord() -> String {
        return self.targetWord
    }
    
    func getCurrentGuess() -> String {
        return self.currentGuess
    }
    
    func getCurrentGame() -> String {
        return self.currentGame
    }
    
    func set_TargetWord(targetWord: String) {
        self.targetWord = targetWord
    }
   
    func set_CurrentGuess(currentGuess: String) {
        self.currentGuess = currentGuess
    }
    
    func set_CurrentGame(currentGame: String) {
        self.currentGame = currentGame
    }

    
}