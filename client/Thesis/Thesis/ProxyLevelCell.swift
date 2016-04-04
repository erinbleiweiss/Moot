//
//  ProxyLevelCell.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/26/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ProxyLevelCell: UIImageView {
    var color: UIColor!
    
    init(image: UIImage, color: UIColor, frame: CGRect) {
        super.init(image: image)
        self.frame = frame
        self.color = color
        self.backgroundColor = color
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
