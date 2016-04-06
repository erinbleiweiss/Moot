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
    var border: [String: Bool] = ["north": false, "east": false, "south": false, "west": false]
    var isStart = false
    var isEnd = false

    var tileSize: CGFloat!
    var borderWidth: CGFloat = 5.0
    
    init(north: Bool, west: Bool, south: Bool, east: Bool, frame: CGRect) {
        self.north = north
        self.west = west
        self.south = south
        self.east = east
        super.init(frame: frame)
        
        self.borderWidth = self.frame.width * 0.1
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
        
        let pathColor = mootBlack
        pathColor.setStroke()

        // Draw North
        if (self.north! && self.border["north"]==true){
            let borderPathN = UIBezierPath()
            borderPathN.lineWidth = borderWidth*2
            borderPathN.moveToPoint(CGPoint(x: 0, y: 0))
            borderPathN.addLineToPoint(CGPoint(x: tileSize, y: 0))
            borderPathN.stroke()
        } else if (self.north!){
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addLineToPoint(CGPoint(x: tileSize, y: 0))
        }

        
        // Draw West
        if (self.west! && self.border["west"]==true && !isStart){
            let borderPathW = UIBezierPath()
            borderPathW.lineWidth = borderWidth*2
            borderPathW.moveToPoint(CGPoint(x: 0, y: 0))
            borderPathW.addLineToPoint(CGPoint(x: 0, y: tileSize))
            borderPathW.stroke()
        } else if (self.west! && !isStart){
            path.moveToPoint(CGPoint(x: 0, y: 0))
            path.addLineToPoint(CGPoint(x: 0, y: tileSize))
        }


        // Draw South
        if (self.south! && self.border["south"]==true){
            let borderPathS = UIBezierPath()
            borderPathS.lineWidth = borderWidth*2
            borderPathS.moveToPoint(CGPoint(x: 0, y: tileSize))
            borderPathS.addLineToPoint(CGPoint(x: tileSize, y: tileSize))
            borderPathS.stroke()
        } else if (self.south!){
            path.moveToPoint(CGPoint(x: 0, y: tileSize))
            path.addLineToPoint(CGPoint(x: tileSize, y: tileSize))
        }

        
        // Draw East
        if (self.east! && self.border["east"]==true && !isEnd){
            let borderPathE = UIBezierPath()
            borderPathE.lineWidth = borderWidth*2
            borderPathE.moveToPoint(CGPoint(x: tileSize, y: 0))
            borderPathE.addLineToPoint(CGPoint(x: tileSize, y: tileSize))
            borderPathE.stroke()
        } else if (self.east! && !isEnd){
            path.moveToPoint(CGPoint(x: tileSize, y: 0))
            path.addLineToPoint(CGPoint(x: tileSize, y: tileSize))
        }
        
        
        // SE Corner
        if (!isStart){
            path.moveToPoint(CGPoint(x:0, y:tileSize-(borderWidth/2)))
            path.addLineToPoint(CGPoint(x:0, y:tileSize))
        }

        // NE Corner
        path.moveToPoint(CGPoint(x:0, y:0))
        path.addLineToPoint(CGPoint(x:0, y:(borderWidth/2)))
        
        // NW Corner
        if (!isEnd){
            path.moveToPoint(CGPoint(x:tileSize, y:0))
            path.addLineToPoint(CGPoint(x:tileSize, y:(borderWidth/2)))
        }

        // SW Corner
        path.moveToPoint(CGPoint(x:tileSize, y:tileSize-(borderWidth/2)))
        path.addLineToPoint(CGPoint(x:tileSize, y:tileSize))


        path.stroke()
        
    }
    
    func setStart(){
        self.isStart = true
    }
    
    func setEnd(){
        self.isEnd = true
    }
    
    

}
