//
//  DragAndDropViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/8/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftSpinner

class JigsawLevelViewController: GenericLevelViewController {
    
    let controller: JigsawGameController
    required init?(coder aDecoder: NSCoder){
        controller = JigsawGameController()
        super.init(coder: aDecoder)
    }
    
    var response: String!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    let scale = Int((ScreenHeight - yOffset) * 0.4)
    
    override func viewWillAppear(animated: Bool) {
        self.displayCamera = true
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 3
        self.setCameraButton(self.controller.level!)

        self.setUpLevel()
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.controller.level != nil {
            self.header?.levelBadge!.update(self.controller.level!)
            self.view.layoutSubviews()
        }
        
        if self.controller.tiles.count == 0 {
            self.setUpLevel()
        }
    }

    
    override func setUpLevel() {
        self.controller.getQRCode(scale, height: scale){ responseObject, error in
            if self.controller.QRImage == nil {
                self.displayNetworkAlert("playing level 3.")
            } else {
                let rows = 3
                let cols = 3
                let tileMargin = 10
                
                //            let image: UIImage = UIImage(named: "qr2")!
                self.generateTiles(self.controller.QRImage!, rows: rows, cols: cols)
                self.generateTargets(rows, cols: cols)
                
                self.controller.tiles = self.controller.tiles.shuffle()
                self.displayTiles(tileMargin, rows: rows, cols: cols)
            }
        }
        
        if self.controller.level != nil {
            self.header?.levelBadge!.update(self.controller.level!)
            self.view.layoutSubviews()
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
        })
        
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
            self.controller.succeed()
        }
    }
    

    override func resetButtonTouched(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Reset", message: "Reset the current level?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let action = UIAlertAction(title: "Reset Level", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            self.controller.resetCurrentLevel()
            self.resetLevel()
        })
        alertController.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) in
        })
        alertController.addAction(cancelAction)
        
        
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = sender.frame
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func resetLevel(){
        for tile in self.controller.tiles{
            tile.removeFromSuperview()
        }
        self.controller.tiles = []
        for target in self.controller.targets{
            target.removeFromSuperview()
        }
        self.controller.targets = []
        self.setUpLevel()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelToJigsawLevelViewController(segue:UIStoryboardSegue) {
        SwiftSpinner.show("Scanning")
        if response != nil{
            self.controller.checkQRCode(response){ responseObject, error in
                if error != nil {
                    self.displayNetworkAlert("playing level 3.")
                }
                if responseObject!["barcode"] == "wrong_barcode"{
                    SwiftSpinner.show("Invalid barcode. Try again!", animated: false)
                    self.delay(2){
                        SwiftSpinner.hide()
                    }
                } else if responseObject!["correcthorsebatterystaple"] == "success"{
                    SwiftSpinner.hide()
                    self.displayLevelCompletionView()
                } else{
                    SwiftSpinner.show("Problem scanning. Try again!", animated: false)
                    self.delay(3){
                        SwiftSpinner.hide()
                    }
                }
            }
        } else {
            SwiftSpinner.show("Problem scanning. Try again!", animated: false)
            self.delay(3){
                SwiftSpinner.hide()
            }
        }

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




    