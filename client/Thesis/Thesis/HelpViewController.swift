//
//  HelpViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/6/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit

class HelpViewController: MootViewController {

    var mootDescription: NSMutableAttributedString!
    
    
    let controller: HelpDataController
    required init?(coder aDecoder: NSCoder) {
        controller = HelpDataController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scale = ScreenWidth / 320
        let topMargin = self.view.frame.height * 0.025
        
        let margin = ScreenHeight * 0.05
        let width = ScreenWidth * 0.9
        let height = ScreenHeight * 0.9
        let descView = UITextView(frame: CGRectMake(margin, margin, width, height - topMargin - margin))
        self.view.addSubview(descView)
        
        var plainString: String = ""
        
        self.controller.getAbout { (responseObject, error) in
            if error != nil {
                plainString = "Moot is a puzzle game that explores various aspects of " +
                "digital culture.  The game requires users to execute " +
                "specific interactions with a digital space. Certain " +
                "levels of the game require users to scan product " +
                "barcodes in order to solve puzzles. Other levels require " +
                "a certain amount of disengagement with the mobile device, " +
                "such as stopping to plug it in or waiting for it to " +
                "charge. The common theme is that no puzzle can be solved " +
                "using the app alone. <br><br> For more information, visit " +
                "http://www.erinbleiweiss.com/moot"
            } else {
                plainString = responseObject!["description"].string!
            }
            
            do {
                
                let font = UIFont(name: "HelveticaNeue", size: 16.0 * scale)!
                self.mootDescription = try NSMutableAttributedString(
                    data: plainString.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                    options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                    documentAttributes: nil
                )
                self.mootDescription.setAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length: self.mootDescription.length))
                
            } catch {
            }
            
            descView.userInteractionEnabled = false
            descView.attributedText = self.mootDescription

        }
        
        
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
