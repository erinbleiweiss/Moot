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
    
    override func viewWillAppear(animated: Bool) {
        self.displayCamera = true
        super.viewWillAppear(animated)
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
                self.controller.compass.unlockColor(color)
            }
        }
        
        if self.controller.level != nil {
            self.header?.levelBadge!.update(self.controller.level!)
            LevelManager.sharedInstance.loadLevels()
            self.controller.refreshData()
            self.view.layoutSubviews()
        }
        
    }


    override func viewDidAppear(animated: Bool) {
        if self.controller.level != nil {
            self.header?.levelBadge!.update(self.controller.level!)
            LevelManager.sharedInstance.loadLevels()
            self.controller.refreshData()
            self.view.layoutSubviews()
        }
    }
    
    
    func generateMaze() {
        self.controller.generateMaze(){ responseObject, error in
            if error != nil {
                self.displayNetworkAlert("playing level 2.")
            } else {
                self.controller.mazeData.set_TileString(responseObject!)
                self.controller.refreshData()
                self.layoutMaze()
            }
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
        if tiles.count > 0 {
            
            let length = tiles.count
            let size_double = sqrt(Double(length))
            let size = Int(size_double)
            
            self.mazeSize = self.mazeTopView!.frame.height - 20.0
            self.tileSize = Int(self.mazeSize!) / size
            
            var row = 0
            var col = 0
            
            let margin = (ScreenWidth - self.mazeSize!) / 2
            self.controller.mazeView = UIView(frame: CGRect(x: margin, y: 20, width: self.mazeSize!, height: self.mazeSize!))
            
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
                
                self.controller.mazeView.addSubview(tileView)
                col+=1
                if (col >= size){
                    col=0
                    row+=1
                }
            }
            
            self.mazeTopView!.addSubview(self.controller.mazeView)
            
            let tokenFrame = CGRect(
                x: self.tileSize! * self.controller.mazeData.getPosCol(),
                y: self.tileSize! * self.controller.mazeData.getPosRow(),
                width: self.tileSize!,
                height: self.tileSize!
            )
            self.controller.tokenView = MazeToken(frame: tokenFrame)
            self.controller.tokenView.backgroundColor = UIColor(white: 1, alpha: 0)
            self.controller.mazeView.addSubview(self.controller.tokenView)
            
            let compassSize = self.mazeBottomView!.frame.height
            let compassFrame = CGRect(
                x: (self.mazeBottomView!.frame.width/2) - (compassSize/2),
                y: 0,
                width: compassSize,
                height: compassSize
            )
            self.controller.compass = CompassView(frame: compassFrame)
            self.mazeBottomView!.addSubview(self.controller.compass)
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event)
        
        var point: CGPoint = (touches.first?.locationInView(self.controller.compass))!
        point = self.controller.compass.convertPoint(point, toView: self.mazeBottomView)
        
        if (self.controller.compass.layer.presentationLayer()?.hitTest(point) != nil){
            var layer: CALayer = (self.controller.compass.layer.presentationLayer()?.hitTest(point))!
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
                    
                    let colorLayer = self.controller.compass.layers[touchedColor!] as! CALayer
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
                            if error != nil {
                                self.displayNetworkAlert("playing level 2.")
                            } else {
                                self.updateToken()
                                let direction = directions[touchedColor!]
                                self.controller.compass.addarrowAnimationCompletionBlock(direction!, completionBlock: { (finished) -> Void    in
                                    let return_code = self.controller.checkForSuccess()
                                    if (return_code == 1){
                                        self.displayStageCompletionView()
                                        self.resetLevel()
                                    } else if (return_code == 2){
                                        self.displayLevelCompletionView()
                                        self.resetLevel()
                                    }
                                })
                            }
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
        if self.upc != "" {
            SwiftSpinner.show("Scanning")
            self.controller.getColor(self.upc!){ responseObject, error in
                if (responseObject["status"] == "success"){
                    self.productName = responseObject["product_name"].string
                    self.color = responseObject["color"].string
                    self.productImgUrl = responseObject["product_img"].string
                    SwiftSpinner.hide()
                    self.controller.compass.unlockColor(self.color)
                    self.controller.mazeData.unlockColor(self.color)
                    self.controller.refreshData()
                    let points_earned = responseObject["points_earned"]
                    self.particles = ["+\(points_earned)"]
                    
                    self.showProductPopup(self.productName!, color: self.color, url: self.productImgUrl!)
                } else {
                    self.showFailure()
                }
            }
        }
    }
    
    
    func showFailure(){
        SwiftSpinner.show("Problem scanning. Try again!", animated: false)
        self.delay(2){
            SwiftSpinner.hide()
        }
    }
    
    
    /**
        Transition to the "Level Completed" controller, then prepare for new nevel
     */
    override func displayLevelCompletionView(){
        if self.controller.level != nil {
            let level = LevelManager.sharedInstance.getLevelByNumber(self.controller.level!)
            let identifier = "\(level.getVCName())Complete"
            self.performSegueWithIdentifier(identifier, sender: nil)
            self.setUpLevel()
        }
    }
    
    override func resetButtonTouched(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Reset", message: "Reset the entire level or just this stage?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Reset Level", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            self.controller.resetCurrentLevel()
            self.resetLevel()
        })
        alertController.addAction(deleteAction)
        
        let okAction = UIAlertAction(title: "Reset Stage", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            self.controller.reset()
            self.resetLevel()
        })
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) in
        })
        alertController.addAction(cancelAction)
        
        
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = sender.frame
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func resetLevel(){
        self.controller.mazeView.removeFromSuperview()
        self.controller.compass.removeFromSuperview()
        self.controller.reset()
        self.generateMaze()
        if self.controller.level != nil {
            self.header?.levelBadge!.update(self.controller.level!)
        }

    }
    
    

}

