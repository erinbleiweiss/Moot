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
        Alamofire.request(.GET, url, parameters: ["width": width, "height": height]).responseJSON { (_, _, result) in
            
            if let img = result.data{
                self.QRImage = UIImage(data: img)
                completionHandler(responseObject: "Success", error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Error", error: result.error as? NSError)
            }
            
        }
    }
    
    
    /**
        Called after every tile placement to determine whether the level has been completed.  Level is considered complete when all tiles are in place.
     
        - Returns: (Bool) True or false indicating level completion
     */
    func checkForSuccess() -> Bool {
        for tile in self.tiles {
            if !tile.isMatched{
                return false
            }
        }
        self.succeed()
        return true
    }
    
}