//
//  MootViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/28/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import MessageUI

class MootViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var hostname = Networking.networkConfig.hostname
    var rest_prefix = Networking.networkConfig.rest_prefix
    
    var displayCamera: Bool = false
    var mailComposerVC: MFMailComposeViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    
    /**
     Wrapper around Apple's dispatch_after() function in order to execute a code
     block after a specified amount of time
     
     - Parameters:
     - delay: (Double) time in seconds
     
     - Returns: none
     
     */
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Display alert when there is a network problem
     */
    func displayNetworkAlert(actionDescription: String){
        let alert = UIAlertController(title: "Network Problem", message: "There was a problem connecting to the Moot servers.  Please check your network connection and contact the developer if this problem persists.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Contact Developer", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            self.mailComposerVC = MFMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.mailComposerVC.mailComposeDelegate = self
                self.mailComposerVC.setToRecipients(["mootthegame@gmail.com"])
                self.mailComposerVC.setSubject("Moot Bug Report")
                self.mailComposerVC.setMessageBody("A problem was encountered when \(actionDescription).<br><br>More details: ", isHTML: true)
                self.presentViewController(self.mailComposerVC, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
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
