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
        let tokenPath = UIBezierPath(ovalInRect: rect)
        UIColor.redColor().setFill()
        tokenPath.fill()
    }

}
