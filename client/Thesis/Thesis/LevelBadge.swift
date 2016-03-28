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
        self.backgroundColor = UIColor(white: 1, alpha: 0)

        self.currentLevelLabel = UILabel(frame: CGRect(x: 0, y: self.bounds.height * 0.4, width: self.bounds.width, height: self.bounds.height * 0.6))
        self.currentLevelLabel.textAlignment = NSTextAlignment.Center
        
        let currentLevel = LevelManager.sharedInstance.getCurrentLevel()
        let currentStage = LevelManager.sharedInstance.getCurrentStage(currentLevel)
        self.currentLevelLabel.text = "\(currentLevel) - \(currentStage)"
        self.currentLevelLabel.sizeLabel()
        self.currentLevelLabel.textColor = UIColor.whiteColor()
        self.addSubview(currentLevelLabel)
        
        self.levelTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height * 0.4))
        self.levelTitleLabel.textAlignment = NSTextAlignment.Center
        self.levelTitleLabel.text = "Level"
        self.levelTitleLabel.sizeLabel()
        self.levelTitleLabel.textColor = UIColor.whiteColor()
        self.addSubview(levelTitleLabel)
        
    }
    
    
    func update(){
        let currentLevel = LevelManager.sharedInstance.getCurrentLevel()
        let currentStage = LevelManager.sharedInstance.getCurrentStage(currentLevel)
        self.currentLevelLabel.text = "\(currentLevel) - \(currentStage)"
        self.currentLevelLabel.sizeLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
}