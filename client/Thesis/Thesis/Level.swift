//
//  Level.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/12/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit

struct Level {

    var levelNumber: Int?
    var VC: String?
    
    init (levelNumber: Int, VC: String){
        self.levelNumber = levelNumber
        self.VC = VC
    }
    
    func getVC() -> UIViewController{
        var viewControllerType = ""
        if let vc = self.VC{
            viewControllerType = vc
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let newVC = storyboard.instantiateViewControllerWithIdentifier(viewControllerType) as? UIViewController
        return newVC!
        
    }
    
}