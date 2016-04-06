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
        
        let halfWidth = self.frame.width / 2
        let margin = halfWidth * 0.05
        let indent = 20 * scale
        
        let numberLabelSize = 45 * scale
        self.numberLabel = UILabel(frame: CGRectMake(indent, 0, numberLabelSize, self.frame.height))
        
        self.nameLabel = UILabel(frame: CGRectMake(indent, 0, halfWidth - margin, self.frame.height))
        self.nameLabel.textAlignment = .Center
        
        self.scoreLabel = UILabel(frame: CGRectMake(halfWidth, 0, halfWidth - margin, self.frame.height))
        self.scoreLabel.textAlignment = .Left

        self.nameLabel.font = UIFont(name: (self.nameLabel.font?.familyName)!, size: 20 * scale)
        self.scoreLabel.font = UIFont(name: (self.scoreLabel.font?.familyName)!, size: 20 * scale)
        self.numberLabel.font = UIFont(name: (self.numberLabel.font?.familyName)!, size: 20 * scale)
        
        self.addSubview(self.nameLabel)
        self.addSubview(self.scoreLabel)
        self.addSubview(self.numberLabel)
    }

    
    
}
