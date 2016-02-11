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
    
}