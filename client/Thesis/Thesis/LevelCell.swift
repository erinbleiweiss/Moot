//
//  LevelCell.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/24/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class LevelCell: UICollectionViewCell {
    var level: Level?
    var levelLabel: UILabel!
    var VC: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addLabel()
        if (self.level?.isLocked() == true){
            displayLock()
        }
    }
    
    func setLevelforCell(level: Level){
        self.level = level
    }
 
    func addLabel(){
        self.levelLabel = UILabel(frame: self.bounds)
        self.levelLabel.textAlignment = NSTextAlignment.Center
        self.levelLabel.textColor = UIColor.whiteColor()
        if let num = level?.levelNumber{
            self.levelLabel.text = String(num)
        }
        self.addSubview(levelLabel)
        
        if let _ = level?.VC{
            self.VC = level!.getVC()
        }
    }
    
    func displayLock(){
        let lockView = UIImageView(image: UIImage(named: "lock"))
        let dim = self.bounds.width / 4.0
        lockView.frame = CGRect(x: self.bounds.width - (dim/2), y: self.bounds.height - (dim/2), width: dim, height: dim)
        self.addSubview(lockView)
        self.bringSubviewToFront(lockView)
    }
    
}
