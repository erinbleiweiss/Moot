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
        Level(levelNumber: 1, VC: "HangmanLevelViewController"),
        Level(levelNumber: 2, VC: "MazeLevelViewController"),
        Level(levelNumber: 3, VC: "JigsawLevelViewController")
    ]
    
    /// Methods
    private init() {} // This prevents others from using the default '()' initializer for this class.
    
    func listLevels() -> [Level]{
        return allLevels
    }
    
}