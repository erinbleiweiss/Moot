//
//  HangmanTile.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/12/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class HangmanTile: UIImageView {
    
    var letter: Character?
    var letterLabel: UILabel!
    var isFilled: Bool = false
    
    init(letter:Character , sideLength:CGFloat) {
        self.letter = "_"
        let image = UIImage(named: "slot")!
        super.init(image: image)
        
        let scale = sideLength / image.size.width
        self.frame = CGRect(x: 0, y: 0, width: image.size.width * scale, height: image.size.height * scale)
        
        self.letterLabel = UILabel(frame: self.bounds)
        self.letterLabel.textAlignment = NSTextAlignment.Center
        self.letterLabel.textColor = UIColor.blueColor()
        self.letterLabel.backgroundColor = UIColor.clearColor()
        self.letterLabel.text = String(letter).uppercaseString
        self.letterLabel.font = UIFont(name: "Verdana-Bold", size: 78.0 * scale)
        self.addSubview(letterLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateLetter(letter: Character){
        self.letter = letter
        self.letterLabel.text = String(letter).uppercaseString
        if (String(letter) != "_") {
            self.isFilled = true
        }
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
