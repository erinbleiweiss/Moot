//
//  QRTile.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/8/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

protocol TileDragDelegateProtocol {
    func tileView(tileView: QRTile, didDragToPoint: CGPoint)
}


class QRTile: UIImageView {

    var id: Int
    var isMatched: Bool = false
    
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0
    
    var dragDelegate: TileDragDelegateProtocol?
    
    
    init(id: Int, image: UIImage) {
        self.id = id
        
        super.init(image: image)
        self.userInteractionEnabled = true
    }
    
    required init(coder aDecoder:NSCoder){
        fatalError("use init(sideLength:)")
    }
    
    
    override func drawRect(rect: CGRect) {
        
        let height = rect.height
        let width = rect.width
        
        let rectangle = CGRect(x: 0, y:0, width: width, height: height)
        let path = UIBezierPath(rect: rectangle)
        
        UIColor.blueColor().setFill()
        path.fill()
        
    }
    
    // Get location of first touch
    // Calculate distance from touch to tile's center
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.locationInView(self.superview?.superview)
            xOffset = point.x - self.center.x
            yOffset = point.y - self.center.y
        }
    }
    
    // Relocate tile to location which finger moved
    // Adjust location by xOffset, yOffset, so tile doesn't center under finger
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.locationInView(self.superview?.superview)
            self.center = CGPointMake(point.x - xOffset, point.y - yOffset)
        }
    }
    
    
    // When touch ends (finger is lifted), move tile to final location
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touchesMoved(touches, withEvent: event)
        dragDelegate?.tileView(self, didDragToPoint: self.center)
    }

}


