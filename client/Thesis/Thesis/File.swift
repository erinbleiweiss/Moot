//
//  File.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/7/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit
import RAMAnimatedTabBarController

class mootFlipLeftAnimation: RAMTransitionItemAnimations {
    
    
    
    override func playAnimation(icon : UIImageView, textLabel : UILabel) {
        

        
        playAnimation(icon, textLabel: textLabel)
        
        // add animation
        //            icon.image = selectedImage
    }

    override func deselectAnimation(icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
        
        playAnimation(icon, textLabel: textLabel)
        // add animation
        //            icon.image = normalImage
    }
    
    override func selectedState(icon: UIImageView, textLabel: UILabel) {
        //
    }
    

}