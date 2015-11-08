//
//  MazeLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/23/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Alamofire

class MazeLevelViewController: GenericLevelViewController {
    var color: String!
    @IBOutlet weak var colorLabel: UILabel!
    

//    let tilesString = "12_8_10_10_9_7_5_12_9_5_14_3_5_6_3_12_9_6_9_13_7_6_10_2_3"
    
    var tileString: String!
    
    var pos_row = 0
    var pos_col = 0
    var tokenView = MazeToken!()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tiles = [String]!()
        
//        let tiles = [12, 8, 10, 10, 9,
//                      7, 5, 12, 9,  5,
//                     14, 3, 5,  6,  3,
//                     12, 9, 6,  9,  13,
//                      7, 6, 10, 2,  3]
        
        generateMaze(5, height: 5){ responseObject, error in
            self.tileString = responseObject!
            tiles = self.tileString.componentsSeparatedByString("_")
            
            let length = tiles.count
            let size_double = sqrt(Double(length))
            let size = Int(size_double)
            
            var row = 0
            var col = 0
            
            for tile in tiles{
                
                let walls = self.getWalls(Int(tile)!)
                
                let north = self.evaluateWall(walls[0])
                let west = self.evaluateWall(walls[1])
                let south = self.evaluateWall(walls[2])
                let east = self.evaluateWall(walls[3])
                
                let frame = CGRect(x: 50 + (100 * (col+1)), y: 200 + (100 * row), width: 100, height: 100)
                let customView = MazeTile(north: north, west: west, south: south, east: east, frame: frame)
                customView.backgroundColor = UIColor(white: 1, alpha: 0.5)
                
                self.view.addSubview(customView)
                col++
                if (col >= size){
                    col=0
                    row++
                }
            }
         
            
            let tokenFrame = CGRect(x: 50 + (100 * (self.pos_col+1)), y: 200 + (100 * self.pos_row), width: 100, height: 100)
            self.tokenView = MazeToken(frame: tokenFrame)
            self.tokenView.backgroundColor = UIColor(white: 1, alpha: 0)
            self.view.addSubview(self.tokenView)
            
        }


        
    }
    
    func getWalls(num: Int) -> String {
        var str = String(num, radix: 2)             // Decimal to binary
        let binaryInt = Int(str)
        str = String(format: "%04d", binaryInt!)    // Pad with zeroes
        return str
    }
    
    func evaluateWall (ch: Character) -> Bool{
        return (ch == "1")
    }
    
    
    @IBAction func moveUp(sender: AnyObject) {
        mazeMove("north"){ responseObject, error in
            print(responseObject!)
            self.updateToken()
            
            print(self.pos_row)
            print(self.pos_col)
        }
    }
    
    @IBAction func moveLeft(sender: AnyObject) {
        mazeMove("west"){ responseObject, error in
            print(responseObject!)
            self.updateToken()
            
            print(self.pos_row)
            print(self.pos_col)
        }
    }
    
    @IBAction func moveDown(sender: AnyObject) {
        mazeMove("south"){ responseObject, error in
            print(responseObject!)
            self.updateToken()
            
            print(self.pos_row)
            print(self.pos_col)
        }
    }
    
    @IBAction func moveRight(sender: AnyObject) {
        mazeMove("east"){ responseObject, error in
            print(responseObject!)
            self.updateToken()
            
            print(self.pos_row)
            print(self.pos_col)
            
        }
    }
    
    func updateToken(){
        self.tokenView.frame = CGRect(x: 50 + (100 * (self.pos_col+1)), y: 200 + (100 * self.pos_row), width: 100, height: 100)
        self.tokenView.setNeedsDisplay()
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

    func mazeMove(dir: String, completionHandler: (responseObject: String?, error: NSError?) -> ()) {
        let url: String = hostname + rest_prefix + "/maze_move"
        Alamofire.request(.GET, url, parameters: ["dir": dir, "maze": tileString, "row": String(self.pos_row), "col": String(self.pos_col)]).responseJSON { (_, _, result) in
            
            
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToMazeLevelViewController(segue:UIStoryboardSegue) {
        self.colorLabel.text = color
    }
    

}


extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
}
