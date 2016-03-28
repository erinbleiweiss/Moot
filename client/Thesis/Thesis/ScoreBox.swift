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
        self.backgroundColor = UIColor(white: 1, alpha: 0)

        self.points = ScoreManager.sharedInstance.getScore()
        self.pointsLabel = UILabel(frame: CGRect(x: 0, y: self.bounds.height * 0.33, width: self.bounds.width, height: self.bounds.height * 0.66))
        self.pointsLabel.textAlignment = NSTextAlignment.Center
        self.pointsLabel.numberOfLines = 1
        if let points = self.points {
                self.pointsLabel.text = String(points)
                self.pointsLabel.sizeLabel()
        }
        self.pointsLabel.textColor = UIColor.whiteColor()
        self.addSubview(pointsLabel)
        
        self.mootPointsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height * 0.33))
        self.mootPointsLabel.textAlignment = NSTextAlignment.Center
        self.mootPointsLabel.numberOfLines = 1
        self.mootPointsLabel.adjustsFontSizeToFitWidth = true
        self.mootPointsLabel.text = "Moot Points"
        self.mootPointsLabel.sizeLabel()
        self.mootPointsLabel.textColor = UIColor.whiteColor()
        self.addSubview(mootPointsLabel)
        
    }
    
    func setPoints(points: Int){
        self.points = points
        self.pointsLabel.text = String(points)
        self.pointsLabel.sizeLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
    }
    
    
}