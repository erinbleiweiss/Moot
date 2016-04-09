//
//  SettingsDataController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/8/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class SettingsDataController: GenericGameController {
    
    func getName(completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/edit_name"
        Alamofire.request(.GET, url, parameters: nil, headers: headers)
            .responseJSON { (_, _, result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    completionHandler(responseObject: json, error: result.error as? NSError)
                case .Failure(_):
                    NSLog("Request failed with error: \(result.error)")
                }
        }
    }
    
    
    func editName(name: String, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/edit_name"
        Alamofire.request(.POST, url, parameters: ["name": name], headers: headers)
            .responseJSON { (_, _, result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    completionHandler(responseObject: json, error: result.error as? NSError)
                case .Failure(_):
                    NSLog("Request failed with error: \(result.error)")
                }
        }
    }
    
    
}