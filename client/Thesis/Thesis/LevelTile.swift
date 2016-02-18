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
    var vc: UIViewController?
    
    init(level: Level?, frame: CGRect){
        super.init(frame: frame)
        
        self.level = level
        
        self.levelLabel = UILabel(frame: self.bounds)
        self.levelLabel.textAlignment = NSTextAlignment.Center
        if let l = level?.levelNumber{
            self.levelLabel.text = String(l)
        }
        self.addSubview(levelLabel)
        
        if let _ = level?.VC{
            self.vc = level!.getVC()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tileSize = Int(self.frame.width)
    }
    
    
    

}