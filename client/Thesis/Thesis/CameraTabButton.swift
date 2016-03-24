//
//  CameraTabButton.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/23/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Spring

// This extension allows the background image of a button to be set within its own frame.  This creates the ability to have a button image that is smaller than the original frame of the button
extension CameraTabButton{
    
    func setImage(image: UIImage?, inFrame frame: CGRect?, forState state: UIControlState){
        self.setImage(image, forState: state)
        
        if(frame != nil){
            self.imageEdgeInsets = UIEdgeInsets(
                top: frame!.minY - self.frame.minY,
                left: frame!.minX - self.frame.minX,
                bottom: self.frame.maxY - frame!.maxY,
                right: self.frame.maxX - frame!.maxX
            )
        }
    }
    
}

class CameraTabButton: SpringButton {

    
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.layer.contentsScale = UIScreen.mainScreen().scale

        let frame = CGRectMake(2.0, 2.0, self.bounds.width - 4.0, self.bounds.height - 4.0)
        let path = UIBezierPath(ovalInRect: frame)
        UIColor.whiteColor().setFill()
        path.fill()
        
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        CGContextSetLineWidth(context, 1.0)
        CGContextAddPath(context, path.CGPath)

        CGContextReplacePathWithStrokedPath(context)
        CGContextClip(context)
        
        let colors = [
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6).CGColor,
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0).CGColor,
        ]
        
        let gradient = CGGradientCreateWithColors(colorSpace, colors, [0.0, 0.65])
        CGContextDrawLinearGradient(context, gradient, CGPoint.zero, CGPoint(x:0, y:self.bounds.height), CGGradientDrawingOptions())
        
        
    }


}
