//
//  MazeData.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 4/4/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit

class MazeData: NSObject, NSCoding{
    
    var tileString: String
    var tokenColor: UIColor
    var pos_row: Int
    var pos_col: Int
    var maze_size: Int
    var unlockedColors: [String]
    
    init(tileString: String, tokenColor: UIColor, pos_row: Int, pos_col: Int, maze_size: Int, unlockedColors: [String]){
        self.tileString = tileString
        self.tokenColor = tokenColor
        self.pos_row = pos_row
        self.pos_col = pos_col
        self.maze_size = maze_size
        self.unlockedColors = unlockedColors
    }
    
    convenience override init(){
        self.init(
            tileString: "",
            tokenColor: UIColor.grayColor(),
            pos_row: 0,
            pos_col: 0,
            maze_size: 5,
            unlockedColors: []
        )
    }

    required convenience init?(coder aDecoder: NSCoder){
        guard let tileString = aDecoder.decodeObjectForKey("tileString") as? String
            else {return nil}
        guard let tokenColor = aDecoder.decodeObjectForKey("tokenColor") as? UIColor
            else {return nil}
        guard let unlockedColors = aDecoder.decodeObjectForKey("unlockedColors") as? [String]
            else {return nil}
        
        self.init(
            tileString: tileString,
            tokenColor: tokenColor,
            pos_row: aDecoder.decodeIntegerForKey("pos_row"),
            pos_col: aDecoder.decodeIntegerForKey("pos_col"),
            maze_size: aDecoder.decodeIntegerForKey("maze_size"),
            unlockedColors: unlockedColors
        )
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(tileString, forKey: "tileString")
        aCoder.encodeObject(tokenColor, forKey: "tokenColor")
        aCoder.encodeInteger(pos_row, forKey: "pos_row")
        aCoder.encodeInteger(pos_col, forKey: "pos_col")
        aCoder.encodeInteger(maze_size, forKey: "maze_size")
        aCoder.encodeObject(unlockedColors, forKey: "unlockedColors")
    }
    
    
    func getTileString() -> String {
        return self.tileString
    }
    
    func getTokenColor() -> UIColor {
        return self.tokenColor
    }
    
    func getPosRow() -> Int {
        return self.pos_row
    }
    
    func getPosCol() -> Int {
        return self.pos_col
    }
    
    func getMazeSize() -> Int {
        return self.maze_size
    }
    
    func getUnlockedColors() -> [String]{
        return self.unlockedColors
    }
    
    func set_TileString(tileString: String) {
        self.tileString = tileString
    }
    
    func set_TokenColor(tokenColor: UIColor) {
        self.tokenColor = tokenColor
    }
    
    func set_posRow(pos_row: Int) {
        self.pos_row = pos_row
    }
    
    func set_posCol(pos_col: Int) {
        self.pos_col = pos_col
    }
    
    func set_mazeSize(maze_size: Int) {
        self.maze_size = maze_size
    }
    
    func set_unlockedColors(unlockedColors: [String]) {
        self.unlockedColors = unlockedColors
    }
    

}