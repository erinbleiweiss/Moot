//
//  ProxyLevelCell.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/26/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ProxyLevelCell: UIView {
    var levelLabel: UILabel!
    
    init(level: Int, color: UIColor, frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = color
        self.levelLabel = UILabel(frame: self.frame)
        self.levelLabel.bounds = self.bounds
        self.levelLabel.text = String(level)
        self.levelLabel.textAlignment = NSTextAlignment.Center
        self.levelLabel.textColor = UIColor.whiteColor()
        self.addSubview(self.levelLabel)
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
