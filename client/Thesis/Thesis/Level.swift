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
 
 */
class Level: NSObject {
    
    var levelNumber: Int?
    var rootVC: String?
    private var locked: Bool = true
    private var currentStage: Int = 1
    private var numStages: Int = 1
    
    func encodeWithCoder(aCoder: NSCoder!){
        aCoder.encodeInteger(levelNumber!, forKey: "levelNumber")
        aCoder.encodeObject(rootVC!, forKey: "rootVC")
        aCoder.encodeBool(locked, forKey: "locked")
        aCoder.encodeInteger(currentStage, forKey: "currentStage")
        aCoder.encodeInteger(numStages, forKey: "numStages")
    }
    
    init(coder aDecoder: NSCoder!){
        levelNumber = aDecoder.decodeIntegerForKey("levelNumber")
        rootVC = aDecoder.decodeObjectForKey("rootVC") as? String
        locked = aDecoder.decodeBoolForKey("locked")
        currentStage = aDecoder.decodeIntegerForKey("currentStage")
        numStages = aDecoder.decodeIntegerForKey("numStages")
    }
    
    override init() {
    }
    
    /**
        Acts as an initializer
    
        - Parameters:
            - levelNumber: (Int)
            - rootVC:      (String)
            - numStages:   (Int)
     */
    func new(levelNumber: Int, rootVC: String, numStages: Int){
        self.levelNumber = levelNumber
        self.rootVC = rootVC
        self.numStages = numStages
    }
    
    /**
        Returns the level's root view from the Main storyboard
     
        - Parameters: none
        - Returns: UIViewController
     
    */
    func getRootVC() -> UIViewController{
        var viewControllerType = ""
        if let vc = self.rootVC{
            viewControllerType = vc
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let newVC = storyboard.instantiateViewControllerWithIdentifier(viewControllerType) as? UIViewController
        return newVC!
        
    }
    
    func getLevelNum() -> Int{
        return self.levelNumber!
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