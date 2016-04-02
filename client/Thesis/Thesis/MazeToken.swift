//
//  MazeToken.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/4/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import DynamicColor

class MazeToken: UIView {

    var tokenColor: UIColor = UIColor.grayColor()
    
    override func drawRect(rect: CGRect) {
        let inset: CGFloat = rect.width * 0.2
        let tokenPath = UIBezierPath(ovalInRect: CGRect(x: inset, y: inset, width: rect.width - (inset * 2), height: rect.height - (inset * 2)))
        tokenPath.lineWidth = rect.width * 0.1
        self.tokenColor.shadeColor(amount: 0.4).setStroke()
        tokenPath.stroke()
        
        self.tokenColor.setFill()
        tokenPath.fill()
    }
    
    func setColor(color: UIColor){
        self.tokenColor = color
    }

}
