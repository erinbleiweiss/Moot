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

class MazeGameController: GenericGameController {
    
    var tileString: String!

    var pos_row = 0
    var pos_col = 0

    var tokenView = MazeToken!()

    
    /**
        Generate a random maze given a specified grid, using a recursive backtracking
        algorithm
     
        - Parameters: 
            - width: (Int) Desired width of maze
            - height: (Int) Desired height of maze
     
        - Returns: a responseObject (JSON), containing the maze with tile presets as underscore_delineated_string
            ex: "12_8_10_10_9_7_5_12_9_5..."
     
     */
    
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
    
    
    
    func mazeMove(dir: String, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/maze_move"
        Alamofire.request(.GET, url, parameters: ["dir": dir, "maze": self.tileString, "row": String(self.pos_row), "col": String(self.pos_col)]).responseJSON { (_, _, result) in
            
            
            let json = JSON(result.value!)
            if let success = json["success"].string{
                if success == "true" {
                    let new_row = String(json["row"])
                    let new_col = String(json["col"])
                    
                    self.pos_row = Int(new_row)!
                    self.pos_col = Int(new_col)!
                    
                    print("moved")
                } else{
                    print("hit wall")
                }
                completionHandler(responseObject: "Success", error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Not Found", error: result.error as? NSError)
            }
            
            
        }
    }
    

}