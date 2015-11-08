//
//  QRTileTarget.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/8/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class QRTileTarget: UIView {
    
    var id: Int
    var isMatched: Bool = false

    init(sideLength: CGFloat, id: Int, frame: CGRect) {
        self.id = id
        
        super.init(frame: frame)
        
        let scale = sideLength / frame.width
        self.frame = CGRect(x: 0, y: 0, width: frame.width * scale, height: frame.height * scale)
        
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
        path.stroke()
        
    }
    
    

}
