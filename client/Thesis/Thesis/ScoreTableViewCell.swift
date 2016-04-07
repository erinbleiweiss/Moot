//
//  ScoreTableViewCell.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/6/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {

    var numberLabel: UILabel!
    var nameLabel: UILabel!
    var scoreLabel: UILabel!
    
    let scale: CGFloat = ScreenWidth / 320

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let height = 50 * scale
        let fontSize = 20 * scale
        
        let y = (height/2) - (fontSize)
        
        let numberWidth = ScreenWidth * 0.13
        let nameWidth = ScreenWidth * 0.47
        let scoreWidth = ScreenWidth * 0.20
        let margin = ScreenWidth * 0.05 // 4 total margins, for a width of 20%
        
        self.numberLabel = UILabel(frame: CGRectMake(margin, y, numberWidth, self.frame.height))
        self.numberLabel.textAlignment = .Right
        
        self.nameLabel = UILabel(frame: CGRectMake((margin * 2) + numberWidth, y, nameWidth, self.frame.height))
        self.nameLabel.textAlignment = .Left
        
        self.scoreLabel = UILabel(frame: CGRectMake((margin * 3) + numberWidth + nameWidth, y, scoreWidth, self.frame.height))
        self.scoreLabel.textAlignment = .Left
        

        self.nameLabel.font = UIFont(name: (self.nameLabel.font?.familyName)!, size: fontSize)
        self.scoreLabel.font = UIFont(name: (self.scoreLabel.font?.familyName)!, size: fontSize)
        self.numberLabel.font = UIFont(name: (self.numberLabel.font?.familyName)!, size: fontSize)
        
        self.addSubview(self.nameLabel)
        self.addSubview(self.scoreLabel)
        self.addSubview(self.numberLabel)
    }

    
    
}
