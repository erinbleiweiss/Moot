//
//  LevelTile.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/16/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Foundation

class LevelTile: UIButton{
    
    var level: Level?
    var levelLabel: UILabel!
    var tileSize: Int!
    var rootVC: UIViewController?
    
    init(level: Level?, frame: CGRect){
        super.init(frame: frame)
        
        self.level = level
        
        self.levelLabel = UILabel(frame: self.bounds)
        self.levelLabel.textAlignment = NSTextAlignment.Center
        self.levelLabel.textColor = UIColor.whiteColor()
        if let num = level?.levelNumber{
            self.levelLabel.text = String(num)
        }
        self.addSubview(levelLabel)
        
        if let _ = level?.rootVC{
            self.rootVC = level!.getRootVC()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tileSize = Int(self.frame.width)
    }
    
    func displayLock(){
        let lockView = UIImageView(image: UIImage(named: "lock"))
        let dim = self.bounds.width / 4.0
        lockView.frame = CGRect(x: self.bounds.width - (dim/2), y: self.bounds.height - (dim/2), width: dim, height: dim)
        self.addSubview(lockView)
        self.bringSubviewToFront(lockView)
    }
    
    
    

}