//
//  CameraTabButton.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/23/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Spring

class CameraTabButton: SpringButton {

    override func drawRect(rect: CGRect) {
        // Drawing code
        
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
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 9.0).CGColor,
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0).CGColor,
        ]
        
        let gradient = CGGradientCreateWithColors(colorSpace, colors, [0.0, 0.65])
        CGContextDrawLinearGradient(context, gradient, CGPoint.zero, CGPoint(x:0, y:self.bounds.height), CGGradientDrawingOptions())
        
    }


}
