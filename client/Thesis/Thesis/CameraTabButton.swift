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

    
    /// Color of the background circle
    var circleColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCircleLayer()
    }
    
    // MARK: Private
    
    private var circleLayer: CAShapeLayer?
    
    private func layoutCircleLayer() {
        if let existingLayer = circleLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(ovalInRect: self.bounds).CGPath
        shapeLayer.strokeColor = UIColor.blackColor().CGColor
        shapeLayer.lineWidth = 2.0
        
        shapeLayer.fillColor = circleColor.CGColor
        self.layer.insertSublayer(shapeLayer, atIndex: 0)
        self.circleLayer = shapeLayer
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
