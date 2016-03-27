//
//  LevelCell.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/24/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class LevelCell: UICollectionViewCell, FlipTransitionCellProtocol {
    var level: Level?
    var levelLabel: UILabel!
    var VC: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blueColor()
        self.levelLabel = UILabel(frame: self.bounds)
        self.levelLabel.textAlignment = NSTextAlignment.Center
        self.levelLabel.textColor = UIColor.whiteColor()
        self.addSubview(levelLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setLevelforCell(self.level!)
        if (self.level?.isLocked() == true){
            displayLock()
        }
    }
    
    func setLevelforCell(level: Level){
        print("setting level \(level.levelNumber)")
        self.level = level
        self.VC = level.getVC()
        self.levelLabel.text = String(level.getLevelNum())
    }
 
    
    func displayLock(){
        let lockView = UIImageView(image: UIImage(named: "lock"))
        let dim = self.bounds.width / 4.0
        lockView.frame = CGRect(x: self.bounds.width - (dim/2), y: self.bounds.height - (dim/2), width: dim, height: dim)
        self.addSubview(lockView)
        self.bringSubviewToFront(lockView)
    }
    
    func transitionViewForCell() -> UIView! {
        let newView: UIView = UIView(frame: self.frame)
        newView.bounds = self.bounds
//        newView.backgroundColor = bgView.backgroundColor
        newView.backgroundColor = UIColor.redColor()
        let newLabel = UILabel(frame: self.levelLabel.frame)
        newLabel.textColor = UIColor.whiteColor()
        newLabel.text = self.levelLabel.text
        newLabel.center = self.center
        newView.addSubview(newLabel)
        return newView
    }
    
}
