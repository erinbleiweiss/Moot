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

var mootColors: [String: UIColor] = [
    "red":          UIColor(red:0.718,   green: 0.196, blue:0.2,     alpha:1),
    "orange":       UIColor(red:0.937,   green: 0.498, blue:0.00392, alpha:1),
    "yellow":       UIColor(red:0.988,   green: 0.792, blue:0.31,    alpha:1),
    "greenyellow":  UIColor(red:0.784,   green: 0.824, blue:0.098,   alpha:1),
    "green":        UIColor(red:0.545,   green: 0.643, blue:0.0314,  alpha:1),
    "teal":         UIColor(red:0.00392, green: 0.533, blue:0.518,   alpha:1),
    "blue":         UIColor(red:0,       green: 0.447, blue:0.725,   alpha:1),
    "purple":       UIColor(red:0.627,   green: 0.333, blue:0.596,   alpha:1)
]



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