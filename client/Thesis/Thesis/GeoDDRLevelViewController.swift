//
//  GeoDDRLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/15/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class GeoDDRLevelViewController: GenericLevelViewController {

    let controller: GeoDDRGameController
    required init?(coder aDecoder: NSCoder){
        controller = GeoDDRGameController()
        super.init(coder: aDecoder)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 5

        self.setUpArrows()
        // Do any additional setup after loading the view.
    }
    
    func setUpArrows() {
        let size = ScreenWidth * 0.95
        let arrowsFrame = CGRect(
            x: (ScreenWidth / 2) - (size / 2),
            y: yOffset + (visibleHeight / 2) - (size / 2),
            width: size,
            height: size
        )
        self.controller.arrows = DDRArrowsView(frame: arrowsFrame)
        self.view.addSubview(self.controller.arrows)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
