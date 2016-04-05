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
    var resetButton: UIButton?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        
        let subviewHeight = self.bounds.height/2
        let subviewWidth = self.bounds.width/2
        
        let mootLogo = UIImageView(image: UIImage(named: "moot_logo"))
        let height = self.frame.height * 0.2
        let scale = height / mootLogo.frame.height
        let width = scale * mootLogo.frame.width
        var x = (ScreenWidth / 2) - (width / 2)
        var y = StatusBarHeight * 1.25
        mootLogo.frame = CGRectMake(x, y, width, height)
        self.addSubview(mootLogo)
        
        let scoreBoxFrame = CGRect(x: 0, y: self.bounds.height - subviewHeight, width: subviewWidth, height: subviewHeight)
        self.scoreBox = ScoreBox(frame: scoreBoxFrame)
        self.addSubview(scoreBox!)
        
        let badgeFrame = CGRect(x: subviewWidth, y: self.bounds.height - subviewHeight, width: subviewWidth, height: subviewHeight)
        self.levelBadge = LevelBadge(frame: badgeFrame)
        self.addSubview(levelBadge!)
        
        let resetImg = UIImage(named: "replay")!
        self.resetButton = UIButton(type: UIButtonType.Custom)
        let buttonSize = self.frame.height / 3
        let margin = buttonSize / 2
        x = ScreenWidth - margin - buttonSize
        y = (yOffset / 2) - (buttonSize / 2) + 5
        self.resetButton!.frame = CGRectMake(x, y, buttonSize, buttonSize)
        self.resetButton!.setImage(resetImg, forState: .Normal)
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
