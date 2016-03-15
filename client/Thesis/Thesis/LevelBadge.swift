//
//  LevelBadge.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/14/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class LevelBadge: UIView{
    
    var levelTitleLabel: UILabel!
    var currentLevelLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.currentLevelLabel = UILabel(frame: CGRect(x: 0, y: self.frame.height / 2, width: self.bounds.width, height: self.frame.height / 2))
        self.currentLevelLabel.textAlignment = NSTextAlignment.Center
        
        let currentLevel = LevelManager.sharedInstance.getCurrentLevel()
        let currentStage = LevelManager.sharedInstance.getCurrentStage(currentLevel)
        self.currentLevelLabel.text = "\(currentLevel) - \(currentStage)"
        self.addSubview(currentLevelLabel)
        
        self.levelTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.frame.height / 2))
        self.levelTitleLabel.textAlignment = NSTextAlignment.Center
        self.levelTitleLabel.text = "Level"
        self.addSubview(levelTitleLabel)
        
    }
    
    func update(){
        let currentLevel = LevelManager.sharedInstance.getCurrentLevel()
        let currentStage = LevelManager.sharedInstance.getCurrentStage(currentLevel)
        self.currentLevelLabel.text = "\(currentLevel) - \(currentStage)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
}