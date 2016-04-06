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
    
    
    var nameTextField: MootTextField!
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = mootBackground
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let scale = ScreenWidth / 320
        
        let loginButton: UIButton = UIButton(type: UIButtonType.Custom)
        let buttonHeight = ScreenHeight * 0.3
        loginButton.frame = CGRectMake(0, ScreenHeight - buttonHeight, ScreenWidth, buttonHeight)
        loginButton.setTitle("Login", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: #selector(LoginViewController.loginButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.titleLabel?.font = UIFont(name: (loginButton.titleLabel?.font?.familyName)!, size: 50 * scale)
        loginButton.backgroundColor = mootColors["blue"]
        self.view.addSubview(loginButton)
        
        let height = 40 * scale
        let width = ScreenWidth * 0.6
        let x = (ScreenWidth / 2) - (width / 2)
        var y = ScreenHeight * 0.3
        self.nameTextField = MootTextField(frame: CGRectMake(x, y, width, height))
        self.nameTextField.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(nameTextField)
        
        y += height
        let nameLabel = UILabel(frame: CGRectMake(x, y, width, height))
        nameLabel.text = "Enter Your Name"
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont(name: (nameLabel.font?.familyName)!, size: 12 * scale)
        nameLabel.textColor = mootBlack
        self.view.addSubview(nameLabel)
    }

    override func viewDidAppear(animated: Bool) {
        // User has logged in before
        if prefs.stringForKey("uuid") != nil{
            self.goToLevelPicker(false)
        }
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func loginButtonPressed(sender: AnyObject) {
        self.tryLogin(self.nameTextField.text!){ responseObject, error in
            if responseObject!["status"] == "success"{
                self.goToLevelPicker(true)
            }
        }
        
    }
    
    
    func tryLogin(name: String, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        
        let url: String = hostname + rest_prefix + "/login"
        
        let uuid = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let password = get_api_key()
        let credentialData = "\(uuid):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]

        Alamofire.request(.GET, url, parameters: ["name": name], headers: headers)
            .responseJSON { (_, _, result) in
            switch result {
            case .Success(let data):
                let json = JSON(data)
                    self.prefs.setObject(uuid, forKey: "uuid")
                completionHandler(responseObject: json, error: result.error as? NSError)
            case .Failure(_):
                NSLog("Request failed with error: \(result.error)")
            }
            
        }
        
    }
    
    
    func goToLevelPicker(animated: Bool){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let revealViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("TabRootVC") as UIViewController
        self.presentViewController(revealViewController, animated: animated, completion: nil)
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
