//
//  EmoticonParticleView.swift
//  EmoticonParticles
//
//  Created by Cem Olcay on 16/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import UIKit

class EmoticonParticleView: UIView {

    
    // MARK: Particles
    var emoticons: [String]
    let colors = ["red", "orange", "yellow", "greenyellow", "green", "teal", "blue", "purple"]

    func CGImageRefOfString (string: String) -> CGImageRef {
    
        let rand = randomNumber(7, MIN: 0)
        let randColor = self.colors[rand]
        let color = mootColors[randColor]
        
        let label = UILabel (frame: CGRectMake(0, 0, 100, 30))
        label.text = string
        label.font = Raleway.Bold.withSize(20)
        label.textColor = color
        label.textAlignment = .Center
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.drawViewHierarchyInRect(label.bounds, afterScreenUpdates: true)
        let ref = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return ref.CGImage!
    }
    
    func emitterCells () -> [CAEmitterCell] {
        var cells: [CAEmitterCell] = []
        
        // increase particle frequency
        for _ in 0...5 {
            emoticons.append(emoticons[0])
        }
        
        for e in emoticons {
            let emitterCell = CAEmitterCell()
            emitterCell.scale = 0.4
            emitterCell.scaleRange = 0.2
            emitterCell.lifetime = 2
            emitterCell.birthRate = 3.0
            emitterCell.velocity = 100.0
            emitterCell.velocityRange = 100.0
            emitterCell.yAcceleration = 300.0
            emitterCell.emissionRange = CGFloat(M_PI)
            emitterCell.contents = CGImageRefOfString(e)
            
            cells.append(emitterCell)
        }
        
        return cells
    }
    
    func setupEmitterLayer () {
        let emitterLayer = CAEmitterLayer ()
        emitterLayer.emitterPosition = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.origin.y)
        emitterLayer.emitterZPosition = 10.0
        emitterLayer.emitterSize = CGSize(width: self.bounds.size.width, height: 0.0)
        emitterLayer.emitterShape = kCAEmitterLayerSphere
        emitterLayer.emitterCells = emitterCells()
        
        self.layer.addSublayer(emitterLayer)
    }
    
    
    
    // MARK: Lifecycle
    
    init(frame: CGRect, emoticons: [String]) {
        self.emoticons = emoticons
        super.init(frame: frame)
        self.setupEmitterLayer()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
