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
    
    private var allLevels = [Level]()
    private var numLevels = 3
    
    /// Methods
    private init() { // This prevents others from using the default '()' initializer for this class.
        loadLevels()
    }
    
    func listLevels() -> [Level]{
        return allLevels
    }
    
    func getCurrentLevel() -> Int {
        var level: Int = 1
        for l in self.allLevels {
            if !l.isLocked(){
                level = l.getLevelNum()
            }
        }
        return level
    }
    
    func isLocked(level: Int) -> Bool {
        let level = allLevels[level - 1]
        return level.isLocked()
    }
    
    func unlockLevel(currentLevel: Int){
        allLevels[currentLevel - 1].unlock()
        saveLevels()
    }
    
    func unlockNextLevel(currentLevel: Int){
        let numLevels = allLevels.count
        if (currentLevel <= numLevels){
            allLevels[currentLevel].unlock()
        }
        saveLevels()
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
        let level = allLevels[currentLevel - 1]
        if level.getCurrentStage() < level.getNumStages(){
            self.allLevels[currentLevel - 1].advanceStage()
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
        
        for (idx, level) in allLevels.enumerate(){
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
        Load levels from Core Data, or load default level if saved level does not exist
     */
    func loadLevels(){
        
        // Initialize default levels in case saved levels do not exist
        var defaultLevels = [Level]()
        for _ in 0...numLevels-1 {
            defaultLevels.append(Level())
        }
        defaultLevels[0].new(1, rootVC: "HangmanRootVC", numStages: 3)
        defaultLevels[1].new(2, rootVC: "MazeRootVC", numStages: 1)
        defaultLevels[2].new(3, rootVC: "JigsawRootVC", numStages: 1)
        
        // Read saved levels from Core Data, or use default levels if necessary
        var userLevels = [Level]()
        for idx in 0...numLevels-1 {
            let path = "mootLevel_\(idx).archive"
            let file = documentsDirectory().stringByAppendingPathComponent(path)
            if let level = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? Level {
                userLevels.append(level)
                print("Success reading level \(idx+1)")
            } else {
                print("Could not read level \(idx+1)")
                userLevels.append(defaultLevels[idx])
            }
        }
        allLevels = userLevels
    }
    
    
    
    
}