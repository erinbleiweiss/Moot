//
//  AboutDataController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/10/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class HelpDataController: GenericGameController {
    
    func getAbout(completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/about_moot"
        Alamofire.request(.GET, url, parameters: nil, headers: headers)
            .responseJSON { (_, _, result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    completionHandler(responseObject: json, error: result.error as? NSError)
                case .Failure(_):
                    NSLog("Request failed with error: \(result.error)")
                    completionHandler(responseObject: JSON([:]), error: result.error as? NSError)
                }
        }
    }
    
}