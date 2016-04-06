//
//  AchievementTableViewCell.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/29/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class AchievementTableViewCell: UITableViewCell {

    var achievementImage: UIImageView!
    var achievementNameLabel: UILabel!
    var achievementDescriptionLabel: UILabel!
    var achievementDateLabel: UILabel!
    
    let cellMargin = ScreenWidth * 0.05
    
    let kTitleSize = 17 * (ScreenWidth / 320)
    let kDescriptionSize = 12 * (ScreenWidth / 320)
    let kDateSize = 10 * (ScreenWidth / 320)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
        let imageWidth = (ScreenWidth * 0.25) - cellMargin
        let imageHeight = imageWidth * 1.279
        self.achievementImage = UIImageView(frame: CGRect(x: cellMargin * 2, y: cellMargin, width: imageWidth, height: imageHeight))
        self.addSubview(achievementImage)
        
        let titleIndent = imageWidth + (3 * cellMargin)
        let titleWidth = (ScreenWidth * 0.75) - (3 * cellMargin)
        self.achievementNameLabel = UILabel(frame: CGRect(x: titleIndent, y: cellMargin, width: titleWidth, height: (kTitleSize * 1.1)))
        self.achievementNameLabel.font = UIFont(name: (self.achievementNameLabel.font?.fontName)!, size: kTitleSize )
        self.addSubview(achievementNameLabel)
        
        let descriptionY = kTitleSize + cellMargin
        self.achievementDescriptionLabel = UILabel(frame: CGRect(x: titleIndent, y: descriptionY, width: titleWidth, height: (kDescriptionSize * 3)))
        self.achievementDescriptionLabel.font = UIFont(name: (self.achievementDescriptionLabel.font?.fontName)!, size: kDescriptionSize)
        self.achievementDescriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.achievementDescriptionLabel.numberOfLines = 3
        self.addSubview(achievementDescriptionLabel)
        
        let dateY = descriptionY + (kDescriptionSize * 2) + cellMargin
        self.achievementDateLabel = UILabel(frame: CGRect(x: titleIndent, y: dateY, width: titleWidth, height: kDateSize))
        self.achievementDateLabel.font = UIFont(name: (self.achievementDateLabel.font?.fontName)!, size: kDateSize)
        self.addSubview(achievementDateLabel)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
