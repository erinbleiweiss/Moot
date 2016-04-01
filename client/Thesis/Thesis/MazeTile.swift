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
    var isStart = false
    var isEnd = false

    
    var tileSize: CGFloat!
    let borderWidth: CGFloat = 5.0
    
    init(north: Bool, west: Bool, south: Bool, east: Bool, frame: CGRect) {
        self.north = north
        self.west = west
        self.south = south
        self.east = east
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tileSize = self.frame.width
    }
    
    override func drawRect(rect: CGRect) {
        
        let path = UIBezierPath()
        path.lineWidth = borderWidth
        
        // Draw North
        if (self.north!){
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addLineToPoint(CGPoint(x: tileSize, y: 0))
        }

        
        // Draw West
        if (self.west! && !isStart){
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addLineToPoint(CGPoint(x: 0, y: tileSize))
        }


        // Draw South
        if (self.south!){
            path.moveToPoint(CGPoint(x: 0, y: tileSize))
            path.addLineToPoint(CGPoint(x: tileSize, y: tileSize))
        }

        
        // Draw East
        if (self.east! && !isEnd){
            path.moveToPoint(CGPoint(x: tileSize, y: 0))
            path.addLineToPoint(CGPoint(x: tileSize, y: tileSize))
        }
        
        
        // SE Corner
        path.moveToPoint(CGPoint(x:0, y:tileSize-(borderWidth/2)))
        path.addLineToPoint(CGPoint(x:0, y:tileSize))

        // NE Corner
        path.moveToPoint(CGPoint(x:0, y:0))
        path.addLineToPoint(CGPoint(x:0, y:(borderWidth/2)))
        
        // NW Corner
        path.moveToPoint(CGPoint(x:tileSize, y:0))
        path.addLineToPoint(CGPoint(x:tileSize, y:(borderWidth/2)))

        // SW Corner
        path.moveToPoint(CGPoint(x:tileSize, y:tileSize-(borderWidth/2)))
        path.addLineToPoint(CGPoint(x:tileSize, y:tileSize))


        UIColor.blueColor().setStroke()
        
        path.stroke()
        
    }
    
    func setStart(){
        self.isStart = true
    }
    
    func setEnd(){
        self.isEnd = true
    }
    
    

}
