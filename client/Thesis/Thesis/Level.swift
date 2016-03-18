//
//  Level.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/12/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit

/**
    Used in LevelManager to hold information about each level in the game
 
    Class Attributes:
        - levelNumber: (Int) Each level should have a unique level number, which defines the order that levels should be played
        - rootVC: (String) corresponds to an identifier on the storyboard that identifies the level's root view controller
        - locked: (Boolean) Indicates whether or not the level is unlocked, and therefore playable.  Default value is true.
        - currentStage: (Int) If the level has multiple stages, indicates the highest unlocked stage
        - numStages: (Int) Indicates the number of stages a level has.  Default value (minimum) is 1.
 
 */
class Level: NSObject, NSCoding {
    
    var levelNumber: Int
    var rootVC: String
    private var locked: Bool
    private var currentStage: Int
    private var numStages: Int
    
    // Default initializer
    init(levelNumber: Int, rootVC: String, locked: Bool, currentStage: Int, numStages: Int){
        self.levelNumber = levelNumber
        self.rootVC = rootVC
        self.locked = locked
        self.currentStage = currentStage
        self.numStages = numStages
    }
    
    
    // Overloaded initializer with default values
    convenience init(levelNumber: Int, rootVC: String, numStages: Int){
        self.init(
            levelNumber: levelNumber,
            rootVC: rootVC,
            locked: true,
            currentStage: 1,
            numStages: numStages
        )
    }
    
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder){
        guard let rootVC = aDecoder.decodeObjectForKey("rootVC") as? String
            else {return nil}
        
        self.init(
            levelNumber: aDecoder.decodeIntegerForKey("levelNumber"),
            rootVC: rootVC,
            locked: aDecoder.decodeBoolForKey("locked"),
            currentStage: aDecoder.decodeIntegerForKey("currentStage"),
            numStages: aDecoder.decodeIntegerForKey("numStages")
        )
    }
    
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeInteger(levelNumber, forKey: "levelNumber")
        aCoder.encodeObject(rootVC, forKey: "rootVC")
        aCoder.encodeBool(locked, forKey: "locked")
        aCoder.encodeInteger(currentStage, forKey: "currentStage")
        aCoder.encodeInteger(numStages, forKey: "numStages")
    }
    
    
    /**
        Returns the level's root view from the Main storyboard
     
        - Parameters: none
        - Returns: UIViewController
     
    */
    func getRootVC() -> UIViewController{
        var viewControllerType = ""
        viewControllerType = self.rootVC

        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let newVC = storyboard.instantiateViewControllerWithIdentifier(viewControllerType) as UIViewController
        return newVC
        
    }
    
    func getLevelNum() -> Int{
        return self.levelNumber
    }
    
    func isLocked() -> Bool{
        return self.locked
    }
    
    func unlock(){
        self.locked = false
    }
    
    func getCurrentStage() -> Int{
        return self.currentStage
    }
    
    func getNumStages() -> Int{
        return self.numStages
    }
    
    func advanceStage(){
        self.currentStage++
    }
    
    

    
    
}