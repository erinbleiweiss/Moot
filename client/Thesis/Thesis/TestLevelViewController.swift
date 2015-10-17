//
//  TestLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 9/28/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit

class TestLevelViewController: UIViewController {
    var productName: String!
    @IBOutlet weak var productLabel: UILabel!
    
    @IBAction func cancelToLevelViewController(segue:UIStoryboardSegue) {
        self.productLabel.text = productName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
