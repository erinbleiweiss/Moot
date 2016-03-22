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
    var VC: String
    private var locked: Bool
    private var currentStage: Int
    private var numStages: Int
    
    // Default initializer
    init(levelNumber: Int, VC: String, locked: Bool, currentStage: Int, numStages: Int){
        self.levelNumber = levelNumber
        self.VC = VC
        self.locked = locked
        self.currentStage = currentStage
        self.numStages = numStages
    }
    
    
    // Overloaded initializer with default values
    convenience init(levelNumber: Int, VC: String, numStages: Int){
        self.init(
            levelNumber: levelNumber,
            VC: VC,
            locked: true,
            currentStage: 1,
            numStages: numStages
        )
    }
    
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder){
        guard let VC = aDecoder.decodeObjectForKey("VC") as? String
            else {return nil}
        
        self.init(
            levelNumber: aDecoder.decodeIntegerForKey("levelNumber"),
            VC: VC,
            locked: aDecoder.decodeBoolForKey("locked"),
            currentStage: aDecoder.decodeIntegerForKey("currentStage"),
            numStages: aDecoder.decodeIntegerForKey("numStages")
        )
    }
    
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeInteger(levelNumber, forKey: "levelNumber")
        aCoder.encodeObject(VC, forKey: "VC")
        aCoder.encodeBool(locked, forKey: "locked")
        aCoder.encodeInteger(currentStage, forKey: "currentStage")
        aCoder.encodeInteger(numStages, forKey: "numStages")
    }
    
    
    /**
        Returns the level's root view from the Main storyboard
     
        - Parameters: none
        - Returns: UIViewController
     
    */
    func getVC() -> UIViewController{
        var viewControllerType = ""
        viewControllerType = self.VC

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