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
    
//    var tileString: String!
//    var tokenColor: UIColor?
//    var pos_row = 0
//    var pos_col = 0
//    var maze_size = 5
    
    var mazeData = MazeData()
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
    
    func generateMaze(completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/generate_maze"
        Alamofire.request(.GET, url, parameters: ["width": self.mazeData.getMazeSize(), "height": self.mazeData.getMazeSize()]).responseJSON { (_, _, result) in
            
            let json = JSON(result.value!)
            if let maze = json["maze"].string{
                completionHandler(responseObject: maze, error: result.error as? NSError)
            } else {
                completionHandler(responseObject: "Could not generate maze", error: result.error as? NSError)
            }
            
            
        }
    }
    
    
    
    // Get color name from UPC
    func getColor(upc: String, completionHandler: (responseObject: JSON, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/image_colors"
        Alamofire.request(.GET, url, parameters: ["upc": upc], headers: headers).responseJSON { (_, _, result) in switch result {
            
            
        case .Success(let data):
            let json = JSON(data)
            completionHandler(responseObject: json, error: result.error as? NSError)
            
            
        case .Failure(_):
            NSLog("Get image color failed with error: \(result.error)")
            completionHandler(responseObject: "Could not get image color", error: result.error as? NSError)
            
            }
            
            
        }
        
    }
    
    
    
    func mazeMove(dir: String, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/maze_move"
        Alamofire.request(.GET, url, parameters: ["dir": dir, "maze": self.mazeData.getTileString(), "row": String(self.mazeData.getPosRow()), "col": String(self.mazeData.getPosCol())], headers: headers).responseJSON { (_, _, result) in
            
            
            let json = JSON(result.value!)
            if let success = json["status"].string{
                if success == "success" {
                    let new_row = String(json["row"])
                    let new_col = String(json["col"])
                    
                    self.mazeData.set_posRow(Int(new_row)!)
                    self.mazeData.set_posCol(Int(new_col)!)
                    self.refreshData()
                    
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
    
    
    /**
        Called after each "maveMove" to determine whether the level has been completed.  Critera for winning: Token has made it to bottom right corner of maze.
     
        - Returns: (Bool) True or False indicating level completion
     */
    func checkForSuccess() -> Bool {
        if ((self.mazeData.getPosRow() == self.mazeData.getMazeSize()-1) && (self.mazeData.getPosCol() == self.mazeData.getMazeSize()-1)){
            self.succeed()
            return true
        }
        return false
    }

    
    
    /**
         Retrieve level from core data
     */
    func loadLevelData(){
        let path = "mootLevel\(self.level!)Data"
        let file = documentsDirectory().stringByAppendingPathComponent(path)
        if let levelData = NSKeyedUnarchiver.unarchiveObjectWithFile(file) as? MazeData {
            self.mazeData = levelData
        } else {
            print("Could not read data for level \(self.level!)")
        }
    }
    
    /**
         Save and load data
     */
    func refreshData(){
        self.saveLevelData(self.mazeData, levelNum: self.level!)
        self.loadLevelData()
    }
    
    
    /**
         Reset level to default values
     */
    func reset(){
        self.mazeData.resetData()
        self.refreshData()
    }
    
    
    
}