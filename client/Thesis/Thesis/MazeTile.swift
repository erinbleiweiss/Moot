//
//  MazeTile.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/3/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class MazeTile: UIView {

    var north: Bool?
    var west: Bool?
    var south: Bool?
    var east: Bool?

    init(frame: CGRect, north: Bool, west: Bool, south: Bool, east: Bool) {
        self.north = north
        self.west = west
        self.south = south
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func drawRect(rect: CGRect) {
        let borderWidth: CGFloat = 5.0
        
        let path = UIBezierPath()
        path.lineWidth = borderWidth
        
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: 100, y: 0))
        
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: 0, y: 100))

        UIColor.blueColor().setStroke()
        
        path.stroke()
        
    }

}
