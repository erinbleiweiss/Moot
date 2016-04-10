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

class LoginViewController: UIViewController {
    
    @IBAction func cancelToLogin(segue:UIStoryboardSegue) {
    }
    
    
    var nameTextField: MootTextField!
    let transitionManager = FadeTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = mootBlack
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func viewDidAppear(animated: Bool) {
        // User has logged in before
        if prefs.stringForKey("uuid") != nil{
            self.goToLevelPicker(false)
        } else {
            self.setupScreen()
        }
    }

    func setupScreen(){
        let scale = ScreenWidth / 320
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let tabVC = storyboard.instantiateViewControllerWithIdentifier("TabRootVC") as! MootTabBarController
        let bgImg = tabVC.getScreenshot()
        let bgImgView = UIImageView(image: bgImg)
        bgImgView.frame = CGRectMake(0, -20, self.view.bounds.width, self.view.bounds.height + 20)
        self.view.addSubview(bgImgView)
        
        let blurredView = bgImgView.createBlurredView()
        self.view.addSubview(blurredView)
        
        let blackView = UIView(frame: self.view.bounds)
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0.4
        self.view.addSubview(blackView)

        
        let loginButton: UIButton = UIButton(type: UIButtonType.Custom)
        let buttonHeight = ScreenHeight * 0.2
        loginButton.frame = CGRectMake(0, ScreenHeight - buttonHeight, ScreenWidth, buttonHeight)
        loginButton.setTitle("Play", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: #selector(LoginViewController.loginButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.titleLabel!.font = Raleway.SemiBold.withSize(50 * scale)
        loginButton.backgroundColor = UIColor.blackColor()
        loginButton.alpha = 0.6
        self.view.addSubview(loginButton)
        
        var y = ScreenHeight * 0.1
        var height = 80 * scale
        let xOffset = ScreenWidth * 0.01
        let mootLogo = UILabel(frame: CGRectMake(-xOffset, y, ScreenWidth, height))
        mootLogo.text = "Moot"
        mootLogo.textAlignment = .Center
        mootLogo.font = Raleway.ExtraBold.withSize(80 * scale)
        mootLogo.textColor = UIColor.whiteColor()
        self.view.addSubview(mootLogo)

        height = 40 * scale
        let width = ScreenWidth * 0.75
        let x = (ScreenWidth / 2) - (width / 2)
        y = ScreenHeight * 0.4
        self.nameTextField = MootTextField(frame: CGRectMake(x, y, width, height))
        self.nameTextField.backgroundColor = UIColor.whiteColor()
        self.nameTextField.font = UIFont(name: (self.nameTextField.font?.familyName)!, size: 20 * scale)
        self.view.addSubview(nameTextField)
        
        y += height
        let nameLabel = UILabel(frame: CGRectMake(x, y, width, height))
        nameLabel.text = "Enter Your Name"
        nameLabel.textAlignment = .Center
        nameLabel.font = Raleway.Regular.withSize(16 * scale)
        nameLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(nameLabel)
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
        
        if name == "" {
            let alert = UIAlertController(title: "Name", message: "Please enter your name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
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
                        prefs.setObject(uuid, forKey: "uuid")
                    completionHandler(responseObject: json, error: result.error as? NSError)
                case .Failure(_):
                    NSLog("Request failed with error: \(result.error)")
                }
                
            }
        }
        
    }
    
    
    func goToLevelPicker(animated: Bool){
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let levelPickerVC: UIViewController = storyboard.instantiateViewControllerWithIdentifier("TabRootVC") as UIViewController
        levelPickerVC.transitioningDelegate = self.transitionManager
        self.presentViewController(levelPickerVC, animated: animated, completion: nil)
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
