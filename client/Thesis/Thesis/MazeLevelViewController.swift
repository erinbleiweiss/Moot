//
//  MazeLevelViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 10/23/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MazeLevelViewController: GenericLevelViewController {
    var color: String!
    @IBOutlet weak var colorLabel: UILabel!
    

//    let tilesString = "12_8_10_10_9_7_5_12_9_5_14_3_5_6_3_12_9_6_9_13_7_6_10_2_3"
    

    let controller: MazeGameController
    required init?(coder aDecoder: NSCoder){
        controller = MazeGameController()
        super.init(coder: aDecoder)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
//        let level = Level(levelNumber: 2)
        
        // Add one layer for all game elements (-200 accounts for height of top bar)
        let gameView = UIView(frame: CGRectMake(0, -200, ScreenWidth, ScreenHeight))
        self.view.addSubview(gameView)
        self.controller.gameView = gameView
        
        var tiles = [String]!()
        
//        let tiles = [12, 8, 10, 10, 9,
//                      7, 5, 12, 9,  5,
//                     14, 3, 5,  6,  3,
//                     12, 9, 6,  9,  13,
//                      7, 6, 10, 2,  3]
        
        self.controller.generateMaze(5, height: 5){ responseObject, error in
            self.controller.tileString = responseObject!
            tiles = self.controller.tileString.componentsSeparatedByString("_")
            
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
         
            
            let tokenFrame = CGRect(x: 50 + (100 * (self.controller.pos_col+1)), y: 200 + (100 * self.controller.pos_row), width: 100, height: 100)
            self.controller.tokenView = MazeToken(frame: tokenFrame)
            self.controller.tokenView.backgroundColor = UIColor(white: 1, alpha: 0)
            self.view.addSubview(self.controller.tokenView)
            
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
        self.controller.mazeMove("north"){ responseObject, error in
            print(responseObject!)
            self.updateToken()
            
            print(self.controller.pos_row)
            print(self.controller.pos_col)
        }
    }
    
    @IBAction func moveLeft(sender: AnyObject) {
        self.controller.mazeMove("west"){ responseObject, error in
            print(responseObject!)
            self.updateToken()
            
            print(self.controller.pos_row)
            print(self.controller.pos_col)
        }
    }
    
    @IBAction func moveDown(sender: AnyObject) {
        self.controller.mazeMove("south"){ responseObject, error in
            print(responseObject!)
            self.updateToken()
            
            print(self.controller.pos_row)
            print(self.controller.pos_col)
        }
    }
    
    @IBAction func moveRight(sender: AnyObject) {
        self.controller.mazeMove("east"){ responseObject, error in
            print(responseObject!)
            self.updateToken()
            
            print(self.controller.pos_row)
            print(self.controller.pos_col)
            
        }
    }
    
    func updateToken(){
        self.controller.tokenView.frame = CGRect(x: 50 + (100 * (self.controller.pos_col+1)), y: 200 + (100 * self.controller.pos_row), width: 100, height: 100)
        self.controller.tokenView.setNeedsDisplay()
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
