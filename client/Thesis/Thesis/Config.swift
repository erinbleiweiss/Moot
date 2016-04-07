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
var yOffset: CGFloat = 75.0
let StatusBarHeight  = UIApplication.sharedApplication().statusBarFrame.size.height

//var yOffset: CGFloat = 0.0

let prefs = NSUserDefaults.standardUserDefaults()

var hostname = Networking.networkConfig.hostname
var rest_prefix = Networking.networkConfig.rest_prefix

// Base 64 encoded secret key
var api_key = "RFY3cEhHdFNTOUZKem1KNXVjRDNWdll1JHgyR3JmUDlGOWIk"

let mootGray = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1)
let mootBackground = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
let mootBlack = UIColor(red: 69/255, green: 69/255, blue: 66/255, alpha: 1)

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

var mootFadedColors: [String: UIColor] = [
    "red":          UIColor(red:0.471, green:0.420, blue:0.420, alpha:1),
    "orange":       UIColor(red:0.510, green:0.467, blue:0.416, alpha:1),
    "yellow":       UIColor(red:0.667, green:0.647, blue:0.596, alpha:1),
    "greenyellow":  UIColor(red:0.447, green:0.451, blue:0.369, alpha:1),
    "green":        UIColor(red:0.345, green:0.353, blue:0.286, alpha:1),
    "teal":         UIColor(red:0.290, green:0.333, blue:0.333, alpha:1),
    "blue":         UIColor(red:0.365, green:0.404, blue:0.431, alpha:1),
    "purple":       UIColor(red:0.490, green:0.463, blue:0.490, alpha:1)
]


/**
    Get the DUUID of the device, for user authorization
 
    - returns: (String) Device UUID
 */
func get_uuid() -> String {
    if prefs.stringForKey("uuid") != nil{
        return prefs.stringForKey("uuid")!
    } else {
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
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

func randomNumber(MAX: UInt32, MIN: UInt32) -> Int{
    return Int(arc4random_uniform(MAX) + MIN)
}