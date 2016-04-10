//
//  PrivacyPolicyViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/6/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: MootViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topMargin = self.view.frame.height * 0.025

        let webView = UIWebView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight - topMargin - 80.0))
        self.view.addSubview(webView)
        
        // Load Webpage
        let url = NSBundle.mainBundle().URLForResource("privacy", withExtension: "html");
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);

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
