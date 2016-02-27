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

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
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
    
    
    func register(username: String, password: String, email: String, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/register"
        Alamofire.request(.POST, url, parameters: ["username": username, "password": password, "email": email]).responseJSON { (request, response, result) in
            
            print(request)
            print(response)
            print(result)
            
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
    
    
    @IBAction func registerButton(sender: AnyObject) {
        if validateData(){
            let username: String = usernameTextField.text!
            let password: String = passwordTextField.text!
            let email: String = emailTextField.text!
            
            self.register(username, password: password, email: email){ responseObject, error in
                
            }
            
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
