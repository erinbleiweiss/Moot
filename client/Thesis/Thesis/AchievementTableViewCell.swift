//
//  AchievementTableViewCell.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/29/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class AchievementTableViewCell: UITableViewCell {

    
    @IBOutlet weak var achievementImage: UIImageView!
    @IBOutlet weak var achievementNameLabel: UILabel!
    @IBOutlet weak var achievementDescriptionLabel: UILabel!
    @IBOutlet weak var achievementDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
