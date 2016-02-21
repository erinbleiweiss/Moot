//
//  AchievementManager.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/21/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation

class AchievementManager{
    
    static let sharedInstance = AchievementManager()
    
    private var allAchievements: [String] = []
    
    private init() {}
    
}