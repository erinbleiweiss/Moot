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
let ScreenBounds     = UIScreen.mainScreen().bounds
let ScreenSize       = ScreenBounds.size
let ScreenWidth      = ScreenSize.width
let ScreenHeight     = ScreenSize.height
var yOffset: CGFloat = 125.0
//var yOffset: CGFloat = 0.0

var hostname = Networking.networkConfig.hostname
var rest_prefix = Networking.networkConfig.rest_prefix

// Base 64 encoded secret key
var api_key = "RFY3cEhHdFNTOUZKem1KNXVjRDNWdll1JHgyR3JmUDlGOWIk"




/**
    Get the DUUID of the device, for user authorization
 
    - returns: (String) Device UUID
 */
func get_uuid() -> String {
    return UIDevice.currentDevice().identifierForVendor!.UUIDString
}


/**
    Get the API Key, and base-64 decode it from the stored (obfuscated) string.  Used for authorization headers.
 
    - returns: (String) API Key
 */
func get_api_key() -> String {
    let decodedData = NSData(base64EncodedString: api_key, options:NSDataBase64DecodingOptions(rawValue: 0))
    let decodedString = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)
    return decodedString as! String
}