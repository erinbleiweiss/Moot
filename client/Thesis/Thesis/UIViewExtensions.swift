//
//  UIViewExtensions.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/7/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func createBlurredView() -> UIView{
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        return blurEffectView
    }
    
    
}