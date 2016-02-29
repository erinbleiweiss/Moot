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
    
    @IBOutlet weak var usernameTextField: UIMaterialTextField!
    @IBOutlet weak var passwordTextField: UIMaterialTextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        usernameTextField.displayErrorText("Username cannot be blank")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateData() -> Bool {
        if let username: String = usernameTextField.text! {
            if let password: String = passwordTextField.text! {
                if username != "" && password != "" {
                    return true
                }
            }
        }
        return false
    }
    
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let username: String = usernameTextField.text!
        let password: String = passwordTextField.text!
            
        self.checkPassword(username, password: password){ responseObject, error in
            if responseObject!["status"] == "success"{
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let revealViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("RevealVC") as UIViewController
                self.presentViewController(revealViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func checkPassword(user: String, password: String, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        
        let url: String = hostname + rest_prefix + "/login"
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]

        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON, headers: headers)
            .responseJSON { (_, _, result) in
            switch result {
            case .Success(let data):
                let json = JSON(data)
                    print(json["status"])
                
                    for (item, subJson):(String, JSON) in json{
                        if (item == "errors"){
                            self.displayErrorMessages(subJson)
                        }
                    }
                completionHandler(responseObject: json, error: result.error as? NSError)
            case .Failure(_):
                NSLog("Request failed with error: \(result.error)")
            }
            
        }
        
    }
    
    func displayErrorMessages(errors: JSON) {
        self.clearAllErrorMessages()
        for (item, subJson): (String, JSON) in errors{
            let text = subJson[0].string
            if (item == "username"){
                self.usernameTextField.displayErrorText(text!)
            } else if (item == "password") {
                self.passwordTextField.displayErrorText(text!)
            }
        }
    }
    
    
    func clearAllErrorMessages() {
        let allFields: [UIMaterialTextField] = [usernameTextField, passwordTextField]
        for field in allFields{
            field.hideErrorText()
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
