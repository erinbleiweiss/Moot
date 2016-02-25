///Users/erin/Dropbox/UT (15-16)/Thesis/client/Thesis/Thesis
//  ScoreManager.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/21/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation

class ScoreManager{
    
    static let sharedInstance = ScoreManager()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    private var currentScore: Int
    
    /// Methods
    private init() {
        self.currentScore = 0
    }
    
    func getScore() -> Int{
        return self.currentScore
    }
    
    func addPoints(points: Int){
        currentScore += points
    }
    
    func saveScore() {
        defaults.setInteger(currentScore, forKey: "currentScore")
    }
    
    
}