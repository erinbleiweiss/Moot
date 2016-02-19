//
//  LevelManager.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/17/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation

class LevelManager{
    
    static let sharedInstance = LevelManager()
    
    var allLevels: [Level] = [
        Level(levelNumber: 1, rootVC: "HangmanRootVC"),
        Level(levelNumber: 2, rootVC: "MazeRootVC"),
        Level(levelNumber: 3, rootVC: "JigsawRootVC")
    ]
    
    /// Methods
    private init() {} // This prevents others from using the default '()' initializer for this class.
    
    func listLevels() -> [Level]{
        return allLevels
    }
    
    func getLevel(currentLevel: Int) -> Level{
        return allLevels[currentLevel - 1]
    }
    
    func unlockLevel(currentLevel: Int){
        allLevels[currentLevel - 1].unlock()
    }
    
    func unlockNextLevel(currentLevel: Int){
        let numLevels = allLevels.count
        if (currentLevel <= numLevels){
            allLevels[currentLevel].unlock()
        }
    }
    
}