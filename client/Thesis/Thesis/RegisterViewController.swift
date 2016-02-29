//
//  RegisterViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 2/25/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController, UITextFieldDelegate, UIMaterialTextFieldDelegate {

    @IBOutlet weak var usernameTextField: UIMaterialTextField!
    @IBOutlet weak var emailTextField: UIMaterialTextField!
    @IBOutlet weak var passwordTextField: UIMaterialTextField!
    @IBOutlet weak var confirmPasswordTextField: UIMaterialTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func validateData() -> Bool {
        if let username: String = usernameTextField.text! {
            if let email: String = emailTextField.text!{
                if let password: String = passwordTextField.text! {
                    if let confirmPassword: String = confirmPasswordTextField.text!{
                        if username != "" && email != "" && password != "" && password == confirmPassword {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    
    func register(username: String, password: String, confirmPassword: String, email: String, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/register"
        Alamofire.request(.POST, url, parameters: ["username": username, "password": password, "confirmPassword": confirmPassword, "email": email]).responseJSON { (_, _, result) in
            switch result {
            case .Success(let data):
                let json = JSON(data)
//                print(json["status"])
//                print(json["errors"])
                
                for (item, subJson):(String, JSON) in json{
                    if (item == "errors"){
                        self.displayErrorMeessages(subJson)
                    }
                }
                
                completionHandler(responseObject: json, error: result.error as? NSError)
            case .Failure(_):
                NSLog("Request failed with error: \(result.error)")
            }
            
        }
        
    }
    
    
    @IBAction func registerButton(sender: AnyObject) {
        let username: String = usernameTextField.text!
        let password: String = passwordTextField.text!
        let confirmPassword: String = confirmPasswordTextField.text!
        let email: String = emailTextField.text!
            
        self.register(username, password: password, confirmPassword: confirmPassword, email: email){ responseObject, error in
                
        }
        
        
    }
    
    func displayErrorMeessages(errors: JSON) {
        self.clearAllErrorMeesages()
        for (item,subJson):(String, JSON) in errors {
            let text = subJson[0].string
            if (item == "username"){
                self.usernameTextField.displayErrorText(text!)
            } else if (item == "email") {
                self.emailTextField.displayErrorText(text!)
            } else if (item == "password") {
                self.passwordTextField.displayErrorText(text!)
            } else if (item == "confirmPassword") {
                self.confirmPasswordTextField.displayErrorText(text!)
            }
        }
    }
    
    func clearAllErrorMeesages() {
        let allFields: [UIMaterialTextField] = [usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
        for field in allFields{
            field.hideErrorText()
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
