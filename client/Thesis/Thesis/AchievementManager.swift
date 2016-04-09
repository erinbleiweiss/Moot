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
    
    private var baseURL: String = "http://www.erinbleiweiss.com/moot/img/"

    let imageUrls = [
        "New Moot on the Block": "new_moot",
        "Savings Account": "savings_account",
        "Taste The Rainbow": "rainbow",
        "Easy as ABC": "abc"
    ]
    
    func getImg(title: String) -> String {
        let imgname = self.imageUrls[title]!
        let imgURL = "\(baseURL)\(imgname)_medal.png"
        return imgURL
    }
    
    func getLocalImg(title: String) -> String{
        let imgname = self.imageUrls[title]
        if imgname != nil {
            let imgURL = "\(imgname!)_medal.png"
            return imgURL
        } else {
            let imgURL = "medal.png"
            return imgURL
        }
    }
    
}
