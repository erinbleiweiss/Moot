//
//  FontExtensions.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/27/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

extension UILabel {
    func sizeLabel(maxSize: CGFloat?=300) {
        
        // Try all font sizes from largest to smallest font size
        var fontSize: CGFloat = maxSize!
        let minFontSize: CGFloat = 5
        
        // Fit label width wize
        let constraintSize: CGSize = CGSizeMake(self.frame.size.width, CGFloat(MAXFLOAT))
        
        while (fontSize > minFontSize){
            // Set current font size
            self.font = UIFont(name: (self.font?.fontName)!, size: fontSize)
            
            // Find label size for current font size
            let textRect: CGRect = self.text!.boundingRectWithSize(
                constraintSize,
                options: .UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: self.font],
                context: nil)
            
            let labelSize: CGSize = textRect.size
            
            // Done, if created label is within target size
            if (labelSize.height <= self.frame.size.height){
                break
            }
            
            // Decrease the font size and try again
            fontSize -= 2
        }

    }
}