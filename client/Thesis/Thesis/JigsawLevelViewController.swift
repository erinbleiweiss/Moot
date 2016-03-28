//
//  DragAndDropViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/8/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Alamofire

class JigsawLevelViewController: GenericLevelViewController {
    
    let controller: JigsawGameController
    required init?(coder aDecoder: NSCoder){
        controller = JigsawGameController()
        super.init(coder: aDecoder)
    }
    
    var response: String!
    @IBOutlet weak var successLabel: UILabel!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 3
        self.setCameraButton(self.controller.level!)

        let gameView = UIView(frame: CGRectMake(0, yOffset, ScreenWidth, ScreenHeight - yOffset))
        self.view.addSubview(gameView)
        self.controller.gameView = gameView

        let scale = Int(self.controller.gameView.frame.height * 0.4)
        
        self.controller.getQRCode(scale, height: scale){ responseObject, error in
            let rows = 3
            let cols = 3
            let tileMargin = 10
            
//            let image: UIImage = UIImage(named: "qr2")!
            self.generateTiles(self.controller.QRImage, rows: rows, cols: cols)
            self.generateTargets(rows, cols: cols)
            
            self.controller.tiles = self.controller.tiles.shuffle()
            self.displayTiles(tileMargin, rows: rows, cols: cols)
            
        }
        
    
    }
    
    func generateTiles(qr: UIImage, rows: Int, cols: Int) {
        let cols = CGFloat(cols)
        let rows = CGFloat(rows)
        
        let width = qr.size.width / cols
        let height = qr.size.height / rows
    
        var id = 0
        for row in 0...Int(rows)-1 {
            for col in 0...Int(cols)-1 {
                let crop = CGRectMake(CGFloat(col) * width, CGFloat(row) * height, width, height)
                let cgImage = CGImageCreateWithImageInRect(qr.CGImage, crop)
                let image: UIImage = UIImage(CGImage: cgImage!)
                
                let tile = QRTile(id: id, image: image)
                self.controller.tiles.append(tile)
                id++
            }
        }
    
    }
    
    func displayTiles(tileMargin: Int, rows: Int, cols: Int){
        var idx = 0
        
        let tileWidth = self.controller.tiles[0].frame.width
        let puzzleSize = tileWidth * sqrt(CGFloat(self.controller.tiles.count))
        let tilesView = UIView(frame: CGRect(
            x: ((ScreenWidth / 2) - (puzzleSize / 2) + (tileWidth / 2) - CGFloat(tileMargin)),
            y: self.controller.gameView.frame.height - puzzleSize - 60,
            width: puzzleSize,
            height: puzzleSize)
        )
        
        for row in 0...rows-1 {
            for col in 0...cols-1 {
                self.controller.tiles[idx].center =
                    CGPointMake(
                        CGFloat(col) * tileWidth + (CGFloat(col) * CGFloat(tileMargin)),
                        CGFloat(row) * tileWidth + (CGFloat(row) * CGFloat(tileMargin))
                )
                self.controller.tiles[idx].dragDelegate = self
                tilesView.addSubview(self.controller.tiles[idx])
                idx++
            }
        }
        
        self.controller.gameView.addSubview(tilesView)
    }
    
    func generateTargets(rows: Int, cols: Int){
        
        let width = self.controller.tiles[0].frame.width
        let height = self.controller.tiles[0].frame.height
        let targetsSize = width * sqrt(CGFloat(self.controller.tiles.count))
        let targetsView = UIView(frame: CGRect(
            x: ((ScreenWidth / 2) - (targetsSize / 2) + (width / 2)),
            y: 40,
            width: targetsSize,
            height: targetsSize)
        )

        var id = 0
        for row in 0...rows-1{
            for col in 0...cols-1{
                let frame = CGRect(x: 0, y: 0, width: width, height: height)
                let targetView = QRTileTarget(id: id, frame: frame)
                targetView.center = CGPointMake(
                    CGFloat(col) * width,
                    CGFloat(row) * height
                )
                targetView.backgroundColor = UIColor(white: 1, alpha: 0.5)
                self.controller.targets.append(targetView)
                targetsView.addSubview(targetView)
                id++
            }
        }
        self.controller.gameView.addSubview(targetsView)
        
    }

    
    func placeTile(tileView: QRTile, targetView: QRTileTarget) {
        
        targetView.isMatched = true
        tileView.isMatched = true
        
        // Disable user interactions for tile
        tileView.userInteractionEnabled = false
        
        // Animation
        UIView.animateWithDuration(0.35,
            delay: 0.00,
            options: UIViewAnimationOptions.CurveEaseOut,
            // During animation:
                // Move tile to target center
                // Set transform to "none" (straighten tile)
            animations: {
                tileView.center = targetView.center
                tileView.transform = CGAffineTransformIdentity
        },
            // After animation:
                // Hide targetView
            completion: {
                (value: Bool) in
                targetView.hidden = true
                if self.controller.checkForSuccess(){
                    self.displayLevelCompletionView()
                }
        })
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelToJigsawLevelViewController(segue:UIStoryboardSegue) {
        self.successLabel.text = response
    }

}

extension JigsawLevelViewController: TileDragDelegateProtocol {
    // A tile was dragged, check if matches target
    
    func tileView(tileView: QRTile, didDragToPoint point: CGPoint) {
        var targetView: QRTileTarget?
        for tv in self.controller.targets {
            if tv.frame.contains(point) && !tv.isMatched {
                targetView = tv
                break
            }
        }
        
        // Check if target was found
        if let targetView = targetView {
            // Check if is match
            if targetView.id == tileView.id {
                self.placeTile(tileView, targetView: targetView)
            }
        }
    }
    
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}




    