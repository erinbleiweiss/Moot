//
//  MootHeader.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/27/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class MootHeader: UIView {

    var scoreBox: ScoreBox?
    var levelBadge: LevelBadge?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        
        let subviewHeight = self.bounds.height/3
        let subviewWidth = self.bounds.width/2
        
        let scoreBoxFrame = CGRect(x: 0, y: self.bounds.height - subviewHeight, width: subviewWidth, height: subviewHeight)
        self.scoreBox = ScoreBox(frame: scoreBoxFrame)
        self.addSubview(scoreBox!)
        
        let badgeFrame = CGRect(x: subviewWidth, y: self.bounds.height - subviewHeight, width: subviewWidth, height: subviewHeight)
        self.levelBadge = LevelBadge(frame: badgeFrame)
        self.addSubview(levelBadge!)
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
