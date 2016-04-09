//
//  JigsawGameController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 1/10/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class JigsawGameController: GenericGameController{
    
    var QRImage: UIImage!
    
    var tiles = [QRTile]()
    var targets = [QRTileTarget]()
    
    func getQRCode(width: Int, height: Int, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/get_qr_code"
        Alamofire.request(.GET, url, parameters: ["width": width, "height": height], headers: headers).responseJSON { (_, _, result) in
            
            if let img = result.data{
                self.QRImage = UIImage(data: img)
                completionHandler(responseObject: "Success", error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Error", error: result.error as? NSError)
            }
            
        }
    }
    
    
    
    
    /**
        Called after scanning barcode to determine whether scanned barcode is the level's QR code
     
        - Returns: (Bool) True or false indicating level completion
     */
    func checkQRCode(barcode: String, completionHandler: (responseObject: JSON?, error: NSError?) -> ()) {
        let url: String = barcode
        print(url)
        Alamofire.request(.GET, url, parameters: nil, headers: headers).responseJSON { (_, _, result) in switch result {
            
            case .Success(let data):
                let json = JSON(data)
                completionHandler(responseObject: json, error: result.error as? NSError)
                
            
            case .Failure(_):
                NSLog("Check barcode failed with error: \(result.error)")
                completionHandler(responseObject: "Could not get image color", error: result.error as? NSError)
            
            }


        }
    }

    
    
    
}