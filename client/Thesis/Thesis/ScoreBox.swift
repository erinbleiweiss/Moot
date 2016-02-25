//
//  ScoreBox.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/21/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class ScoreBox: UIView{
    
    var points: Int?
    var mootPointsLabel: UILabel!
    var pointsLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.points = ScoreManager.sharedInstance.getScore()
        self.pointsLabel = UILabel(frame: CGRect(x: 0, y: self.frame.height / 2, width: self.bounds.width, height: self.frame.height / 2))
        self.pointsLabel.textAlignment = NSTextAlignment.Center
        if let points = self.points {
                self.pointsLabel.text = String(points)
        }
        self.addSubview(pointsLabel)
        
        self.mootPointsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.frame.height / 2))
        self.mootPointsLabel.textAlignment = NSTextAlignment.Center
        self.mootPointsLabel.text = "Moot Points"
        self.addSubview(mootPointsLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    
    
}