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
import SwiftSpinner

class MazeLevelViewController: GenericLevelViewController {
    var color: String!
    var compass: CompassView?
    var mazeSize: CGFloat?
    var tileSize: Int?
    
    var upc: String?          // UPC of product scanned
    var productName: String?
    var productImgUrl: String?
    
//    let tilesString = "12_8_10_10_9_7_5_12_9_5_14_3_5_6_3_12_9_6_9_13_7_6_10_2_3"

    var mazeTopView: UIView?
    var mazeBottomView: UIView?
    
    let controller: MazeGameController
    required init?(coder aDecoder: NSCoder){
        controller = MazeGameController()
        super.init(coder: aDecoder)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 2
        self.controller.loadLevelData()
    
        self.setCameraButton(self.controller.level!)
        
        self.mazeTopView = UIView(frame: CGRectMake(0, navBarHeight, visibleWidth, visibleHeight * 0.6))
        let mazeTopHeight = (self.mazeTopView?.frame.height)!
        let mazeBottomHeight = visibleHeight - mazeTopHeight
        self.mazeBottomView = UIView(frame: CGRectMake(0, navBarHeight + mazeTopHeight, visibleWidth, mazeBottomHeight))
        self.view.addSubview(mazeTopView!)
        self.view.addSubview(mazeBottomView!)
        
        if self.controller.mazeData.getTileString() == "" {
            self.generateMaze()
        } else {
            self.layoutMaze()
            self.updateToken()
            for color in self.controller.mazeData.getUnlockedColors() {
                self.compass!.unlockColor(color)
            }
        }
        
    }

    
    func generateMaze() {
        self.controller.generateMaze(){ responseObject, error in
            self.controller.mazeData.set_TileString(responseObject!)
            self.controller.refreshData()
            self.layoutMaze()
        }
    }
    
    
    func layoutMaze() {
//        let tiles = [12, 8, 10, 10, 9,
//                      7, 5, 12, 9,  5,
//                     14, 3, 5,  6,  3,
//                     12, 9, 6,  9,  13,
//                      7, 6, 10, 2,  3]

        var tiles: [String] = []
        tiles = self.controller.mazeData.getTileString().componentsSeparatedByString("_")
        
        let length = tiles.count
        let size_double = sqrt(Double(length))
        let size = Int(size_double)
        
        self.mazeSize = self.mazeTopView!.frame.height - 20.0
        self.tileSize = Int(self.mazeSize!) / size
        
        var row = 0
        var col = 0
        
        let margin = (ScreenWidth - self.mazeSize!) / 2
        let mazeView = UIView(frame: CGRect(x: margin, y: 20, width: self.mazeSize!, height: self.mazeSize!))
        
        for tile in tiles{
            
            let walls = self.getWalls(Int(tile)!)
            
            let north = self.evaluateWall(walls[0])
            let west = self.evaluateWall(walls[1])
            let south = self.evaluateWall(walls[2])
            let east = self.evaluateWall(walls[3])
            
            let frame = CGRect(
                x: self.tileSize! * col,
                y: self.tileSize! * row,
                width: self.tileSize!,
                height: self.tileSize!
            )
            let tileView = MazeTile(north: north, west: west, south: south, east: east, frame: frame)
            tileView.backgroundColor = UIColor(white: 1, alpha: 0.5)
            
            if (row == 0 && col == 0){
                tileView.setStart()
            } else if ((row == size-1) && (col == size-1)){
                tileView.setEnd()
            }
            
            
            // Determine if tile is a border tile
            if row == 0 {
                tileView.border["north"] = true
            }
            if col == size-1 {
                tileView.border["east"] = true
            }
            if row == size-1 {
                tileView.border["south"] = true
            }
            if col == 0 {
                tileView.border["west"] = true
            }
            
            mazeView.addSubview(tileView)
            col+=1
            if (col >= size){
                col=0
                row+=1
            }
        }
        
        self.mazeTopView!.addSubview(mazeView)
        
        let tokenFrame = CGRect(
            x: self.tileSize! * self.controller.mazeData.getPosCol(),
            y: self.tileSize! * self.controller.mazeData.getPosRow(),
            width: self.tileSize!,
            height: self.tileSize!
        )
        self.controller.tokenView = MazeToken(frame: tokenFrame)
        self.controller.tokenView.backgroundColor = UIColor(white: 1, alpha: 0)
        mazeView.addSubview(self.controller.tokenView)
        
        let compassSize = self.mazeBottomView!.frame.height
        let compassFrame = CGRect(
            x: (self.mazeBottomView!.frame.width/2) - (compassSize/2),
            y: 0,
            width: compassSize,
            height: compassSize
        )
        self.compass = CompassView(frame: compassFrame)
        self.mazeBottomView!.addSubview(self.compass!)
    
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event)
        
        var point: CGPoint = (touches.first?.locationInView(self.compass))!
        point = self.compass!.convertPoint(point, toView: self.mazeBottomView)
        
        if (self.compass!.layer.presentationLayer()?.hitTest(point) != nil){
            var layer: CALayer = (self.compass!.layer.presentationLayer()?.hitTest(point))!
            layer = layer.modelLayer() as! CALayer
            
            if layer.descriptiveName != nil {
                let color_layers: [String: String] = [
                    "red_touch": "red",
                    "orange_touch": "orange",
                    "yellow_touch": "yellow",
                    "greenyellow_touch": "greenyellow",
                    "green_touch": "green",
                    "teal_touch": "teal",
                    "blue_touch": "blue",
                    "purple_touch": "purple"
                ]
                let layerName = layer.descriptiveName
                if color_layers[layerName!] != nil{
                    let touchedColor = color_layers[layerName!]
                    self.controller.mazeData.set_TokenColor(mootColors[touchedColor!]!)
                    self.controller.refreshData()
                    
                    let colorLayer = self.compass!.layers[touchedColor!] as! CALayer
                    if colorLayer.locked == false {
                        let directions: [String: CGFloat] = [
                            "red": 0,
                            "orange": 45,
                            "yellow": 90,
                            "greenyellow": 135,
                            "green": 180,
                            "teal": 225,
                            "blue": 270,
                            "purple": 315
                        ]
                        let cardinal_directions: [String: String] = [
                            "red": "north",
                            "orange": "northeast",
                            "yellow": "east",
                            "greenyellow": "southeast",
                            "green": "south",
                            "teal": "southwest",
                            "blue": "west",
                            "purple": "northwest"
                        ]
                        self.controller.mazeMove(cardinal_directions[touchedColor!]!){ responseObject, error in
                            self.updateToken()
                            let direction = directions[touchedColor!]
                            self.compass!.addarrowAnimationCompletionBlock(direction!, completionBlock: { (finished) -> Void    in
                                if self.controller.checkForSuccess() {
                                    self.displayLevelCompletionView()
                                }
                            })
                        }
                    }
                }
            }
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
    
    func updateToken(){
        self.controller.tokenView.frame = CGRect(
            x: self.tileSize! * self.controller.mazeData.getPosCol(),
            y: self.tileSize! * self.controller.mazeData.getPosRow(),
            width: self.tileSize!,
            height: self.tileSize!
        )
        self.controller.tokenView.setColor(self.controller.mazeData.getTokenColor())
        self.controller.tokenView.setNeedsDisplay()
    }
    



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToMazeLevelViewController(segue:UIStoryboardSegue) {
        updateGame()
    }
    
    
    
    func updateGame(){
        if self.upc != nil{
            showSuccess()
        } else {
            showFailure()
        }
    }
    
    func showSuccess(){
        SwiftSpinner.show("Scanning")
        self.controller.getColor(self.upc!){ responseObject, error in
            if (responseObject["status"] == "success"){
                self.productName = responseObject["product_name"].string
                self.color = responseObject["color"].string
                self.productImgUrl = responseObject["product_img"].string
                SwiftSpinner.hide()
                self.compass!.unlockColor(self.color)
                self.controller.mazeData.unlockColor(self.color)
                self.controller.refreshData()
                self.showProductPopup(self.productName!, color: self.color, url: self.productImgUrl!)
                
            } else {
                self.showFailure()
            }
        }
    }
    
    
    func showFailure(){
        SwiftSpinner.show("Problem scanning. Try again!", animated: false)
        self.delay(2){
            SwiftSpinner.hide()
        }
    }
    
    
    

}

