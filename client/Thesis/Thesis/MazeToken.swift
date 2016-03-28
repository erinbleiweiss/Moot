//
//  MazeToken.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/4/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class MazeToken: UIView {

    override func drawRect(rect: CGRect) {
        let tokenPath = UIBezierPath(ovalInRect: CGRect(x: 5, y: 5, width: rect.width - 10, height: rect.height - 10))
        UIColor.redColor().setFill()
        tokenPath.fill()
    }

}
