//
//  LoginViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/25/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate, UIMaterialTextFieldDelegate  {
    @IBAction func cancelToLogin(segue:UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton: UIButton = UIButton(type: UIButtonType.Custom)
        let buttonHeight = ScreenHeight * 0.3
        loginButton.frame = CGRectMake(0, ScreenHeight - buttonHeight, ScreenWidth, buttonHeight)
        loginButton.setTitle("Login", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: #selector(LoginViewController.loginButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.titleLabel?.font = UIFont(name: (loginButton.titleLabel?.font?.familyName)!, size: 50)
        loginButton.backgroundColor = mootColors["blue"]
        self.view.addSubview(loginButton)

        // Do any additional setup after loading the view.
        
//        usernameTextField.displayErrorText("Username cannot be blank")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loginButtonPressed(sender: AnyObject) {
        self.tryLogin(){ responseObject, error in
            if responseObject!["status"] == "success"{

                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let revealViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("TabRootVC") as UIViewController
                self.presentViewController(revealViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func tryLogin(completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        
        let url: String = hostname + rest_prefix + "/login"
        
        let uuid = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let password = get_api_key()
        let credentialData = "\(uuid):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]

        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON, headers: headers)
            .responseJSON { (_, _, result) in
            switch result {
            case .Success(let data):
                let json = JSON(data)
                    print(json["status"])
                completionHandler(responseObject: json, error: result.error as? NSError)
            case .Failure(_):
                NSLog("Request failed with error: \(result.error)")
            }
            
        }
        
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
