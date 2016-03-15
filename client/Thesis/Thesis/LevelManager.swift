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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    private var allLevels: [Level] = [
        Level(levelNumber: 1, rootVC: "HangmanRootVC", numStages: 3),
        Level(levelNumber: 2, rootVC: "MazeRootVC", numStages: 1),
        Level(levelNumber: 3, rootVC: "JigsawRootVC", numStages: 1)
    ]
    
    /// Methods
    private init() {} // This prevents others from using the default '()' initializer for this class.
    
    func listLevels() -> [Level]{
        return allLevels
    }
    
    func getLevel(currentLevel: Int) -> Level{
        return allLevels[currentLevel - 1]
    }
    
    func isLocked(level: Int) -> Bool {
        let level = allLevels[level - 1]
        return level.isLocked()
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
    
    func getCurrentStage(currentLevel: Int) -> Int{
        let level = allLevels[currentLevel - 1]
        return level.getCurrentStage()
    }

    func getNumStages(currentLevel: Int) -> Int{
        let level = allLevels[currentLevel - 1]
        return level.getNumStages()
    }
    
    func advancetoNextStage(currentLevel: Int){
        var level = allLevels[currentLevel]
        if level.getCurrentStage() < level.getNumStages(){
            level.advanceStage()
        }
    }
    
    func saveLevels(){
        
    }
    
}