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
        let newView = ProxyLevelCell(level: (self.level?.getLevelNum())!, color: self.backgroundColor!, frame: self.frame)
        return newView
    }
    
}
