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
        let frame = CGRectMake(0, 0, self.bounds.width * 0.5, self.bounds.height * 0.5)
        let x = (self.bounds.width / 2) - (frame.width / 2)
        let y = (self.bounds.height / 2) - (frame.height / 2)
        self.levelLabel = UILabel(frame: CGRectMake(x, y, frame.width, frame.height))
        self.levelLabel.textAlignment = NSTextAlignment.Center
        self.levelLabel.textColor = UIColor.whiteColor()
        self.addSubview(levelLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setLevelforCell(level: Level){
        self.level = level
        self.VC = level.getVC()
        if (self.level?.isLocked() == true){
            displayLock()
        } else {
            self.levelLabel.text = String(level.getLevelNum())
            self.levelLabel.sizeLabel()
        }
    }
 
    
    func displayLock(){
        let lockView = UIImageView(image: UIImage(named: "lock"))
        let dim = self.bounds.width / 2
        let x = self.bounds.width/2 - dim/2
        let y = self.bounds.height/2 - dim/2
        lockView.frame = CGRectMake(x, y, dim, dim)
        self.addSubview(lockView)
    }
    
    func transitionViewForCell() -> UIView! {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let newView = ProxyLevelCell(image: image, color: self.backgroundColor!, frame: self.frame)
        return newView
    }
    
}
