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

//    
//    /// Color of the background circle
//    var circleColor: UIColor = UIColor.whiteColor() {
//        didSet {
//            self.setNeedsLayout()
//        }
//    }
//    
//    // MARK: Overrides
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layoutCircleLayer()
//    }
//    
//    // MARK: Private
//    
//    private var circleLayer: CAShapeLayer?
//    
//    private func layoutCircleLayer() {
//        if let existingLayer = circleLayer {
//            existingLayer.removeFromSuperlayer()
//        }
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = UIBezierPath(ovalInRect: self.bounds).CGPath
//        shapeLayer.strokeColor = UIColor.blackColor().CGColor
//        shapeLayer.lineWidth = 0.0
//                
//        shapeLayer.fillColor = circleColor.CGColor
//        
//        let colorspace = CGColorSpaceCreateDeviceRGB()
//        let gradient = CGGradientCreateWithColors(colorspace, [UIColor.blackColor(), UIColor(red: 1, green: 1, blue: 1, alpha: 0)], [0.0, 1.0])
//        CGContextSetLineWidth(context, 1.0)
//        
//        self.layer.insertSublayer(shapeLayer, atIndex: 0)
//        self.circleLayer = shapeLayer
//    }
    
    

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let frame = CGRectMake(0.0, 0.0, self.bounds.width - 5.0, self.bounds.height - 5.0)
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
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0).CGColor,
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0).CGColor,
        ]
        
        let gradient = CGGradientCreateWithColors(colorSpace, colors, [0.0, 0.5])
        CGContextDrawLinearGradient(context, gradient, CGPoint.zero, CGPoint(x:0, y:self.bounds.height), CGGradientDrawingOptions())
        
    }


}
