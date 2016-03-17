//
//  Config.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/12/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit

//UI Constants
let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height

var hostname = Networking.networkConfig.hostname
var rest_prefix = Networking.networkConfig.rest_prefix

// Base 64 encoded secret key
var api_key = "RFY3cEhHdFNTOUZKem1KNXVjRDNWdll1JHgyR3JmUDlGOWIk"

func get_api_key() -> String {
    let decodedData = NSData(base64EncodedString: api_key, options:NSDataBase64DecodingOptions(rawValue: 0))
    let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)
    return decodedString as! String
}