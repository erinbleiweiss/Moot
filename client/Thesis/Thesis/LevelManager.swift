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
    
    // Initialize default levels in case saved levels do not exist
    private var defaultLevels: [Level] = [
        Level(levelNumber: 1, VC: "Hangman", numStages: 2),
        Level(levelNumber: 2, VC: "Maze", numStages: 1),
        Level(levelNumber: 3, VC: "Jigsaw", numStages: 1)
    ]
    private var userLevels = [Level]()
    
    /// Methods
    private init() { // This prevents others from using the default '()' initializer for this class.
        loadLevels()
    }
    
    func listLevels() -> [Level]{
        return userLevels
    }
    
    func getCurrentLevel() -> Int {
        var level: Int = 1
        for l in self.userLevels {
            if !l.isLocked(){
                level = l.getLevelNum()
            }
        }
        return level
    }
    
    func isLocked(level: Int) -> Bool {
        let level = userLevels[level - 1]
        return level.isLocked()
    }
    
    func unlockLevel(currentLevel: Int){
        userLevels[currentLevel - 1].unlock()
        saveLevels()
    }
    
    func unlockNextLevel(currentLevel: Int){
        let numLevels = userLevels.count
        if (currentLevel < numLevels){
            userLevels[currentLevel].unlock()
        }
        saveLevels()
    }
    
    func getCurrentStage(currentLevel: Int) -> Int{
        let level = userLevels[currentLevel - 1]
        return level.getCurrentStage()
    }

    func getNumStages(currentLevel: Int) -> Int{
        let level = userLevels[currentLevel - 1]
        return level.getNumStages()
    }
    
    func advancetoNextStage(currentLevel: Int){
        let level = userLevels[currentLevel - 1]
        if level.getCurrentStage() < level.getNumStages(){
            self.userLevels[currentLevel - 1].advanceStage()
        }
        saveLevels()
    }
    

    private func documentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0] as String
        return documentDirectory
    }
    
    
    /**
        Save levels to Core Data
     */
    func saveLevels(){
        for (idx, level) in self.userLevels.enumerate(){
            let path = "mootLevel_\(idx).archive"
            let file = documentsDirectory().stringByAppendingPathComponent(path)
            if NSKeyedArchiver.archiveRootObject(level, toFile: file) {
                print("Success writing level \(idx+1)!")
            } else {
                print("Unable to write level \(idx+1)!")
            }
        }

    }
    
    /**
        Load levels from Core Data into self.userLevels, or load default level if saved level does not exist
     */
    func loadLevels(){
        for idx in 0...self.defaultLevels.count-1 {
            let path = "mootLevel_\(idx).archive"
            let file = documentsDirectory().stringByAppendingPathComponent(path)
            if let level = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? Level {
                self.userLevels.append(level)
                print("Success reading level \(idx+1)")
            } else {
                print("Could not read level \(idx+1)")
                self.userLevels.append(self.defaultLevels[idx])
            }
        }
    }
    
    
    
    
}