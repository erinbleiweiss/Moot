//
//  MazeGameController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 1/5/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class MazeGameController {
    var gameView: UIView!
    var level: Level!
    
    var tileString: String!

    var pos_row = 0
    var pos_col = 0

    var tokenView = MazeToken!()

    init(){
    }
    
    func generateMaze(width: Int, height: Int, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/generate_maze"
        Alamofire.request(.GET, url, parameters: ["width": width, "height": height]).responseJSON { (_, _, result) in
            
            let json = JSON(result.value!)
            if let maze = json["maze"].string{
                completionHandler(responseObject: maze, error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Could not generate maze", error: result.error as? NSError)
            }
            
            
        }
    }

}