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
struct Level {
    
    var levelNumber: Int?
    var rootVC: String?
    var locked: Bool = true
    
    init (levelNumber: Int, rootVC: String){
        self.levelNumber = levelNumber
        self.rootVC = rootVC
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
    
    mutating func unlock(){
        self.locked = false
    }
    
}