//
//  LevelNavController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/27/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class LevelNavController: UINavigationController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
}
