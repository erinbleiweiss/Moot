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

        let scale = Int(self.visibleHeight * 0.4)
        
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
                id+=1
            }
        }
    
    }
    
    func displayTiles(tileMargin: Int, rows: Int, cols: Int){
        var idx = 0
        
        let tileDim = sqrt(CGFloat(self.controller.tiles.count))
        let puzzleSize = (visibleHeight / 2) * 0.8
        let tileSize = puzzleSize / tileDim
        let tileMargin = tileSize * 0.2
        
        let totalWidth = (tileSize + tileMargin) * CGFloat(tileDim)
        let originX = (visibleWidth / 2) - (totalWidth / 2)
        let originY = (visibleHeight / 2) + navBarHeight
        
        for row in 0...rows-1 {
            for col in 0...cols-1 {
                self.controller.tiles[idx].frame = CGRectMake(
                    originX + ((tileSize + tileMargin) * CGFloat(col)),
                    originY + ((tileSize + tileMargin) * CGFloat(row)),
                    tileSize,
                    tileSize
                )
                self.controller.tiles[idx].dragDelegate = self
                self.view.addSubview(self.controller.tiles[idx])
                idx+=1
            }
        }
        
    }
    
    func generateTargets(rows: Int, cols: Int){
        
        let tileDim = sqrt(CGFloat(self.controller.tiles.count))
        let puzzleSize = (visibleHeight / 2) * 0.8
        let tileSize = puzzleSize / tileDim
        let tileMargin = tileSize * 0.2

        let totalWidth = tileSize * CGFloat(tileDim)
        let originX = (visibleWidth / 2) - (totalWidth / 2)
        let originY = navBarHeight + tileMargin
        
        var idx = 0
        for row in 0...rows-1{
            for col in 0...cols-1{
                let frame = CGRectMake(
                    originX + (tileSize * CGFloat(col)),
                    originY + (tileSize * CGFloat(row)),
                    tileSize,
                    tileSize
                )
                let targetView = QRTileTarget(id: idx, frame: frame)
                targetView.backgroundColor = UIColor(white: 1, alpha: 0.5)
                self.controller.targets.append(targetView)
                self.view.addSubview(targetView)
                idx+=1
            }
        }
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




    