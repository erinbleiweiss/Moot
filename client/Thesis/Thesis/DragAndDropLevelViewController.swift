//
//  DragAndDropViewController.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 11/8/15.
//  Copyright © 2015 Erin Bleiweiss. All rights reserved.
//

import UIKit
import Alamofire

class DragAndDropLevelViewController: GenericLevelViewController {

    private var tiles = [QRTile]()
    private var targets = [QRTileTarget]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame2 = CGRect(x: 0, y: 0, width: 100, height: 100)
        let targetView = QRTileTarget(sideLength: 100, id: 0, frame: frame2)
        targetView.center = CGPointMake(300, 300)
        targetView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        targets.append(targetView)
        self.view.addSubview(targetView)
        
//        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let image: UIImage = UIImage(named: "qr")!
        
        let rows = 5
        let cols = 5
        let tileMargin = 10
        
        generateTiles(image, rows: rows, cols: cols)
        
        var idx = 0
        for row in 0...rows-1 {
            for col in 0...cols-1 {
                self.tiles[idx].center = CGPointMake(100 + CGFloat(col) * self.tiles[idx].frame.width + CGFloat(tileMargin),
                                                    100 + CGFloat(row) * self.tiles[idx].frame.height + CGFloat(tileMargin))
                self.tiles[idx].dragDelegate = self
                self.view.addSubview(self.tiles[idx])
                idx++
            }
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
                self.tiles.append(tile)
                id++
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelToDragAndDropLevelViewController(segue:UIStoryboardSegue) {
        
    }

}

extension DragAndDropLevelViewController: TileDragDelegateProtocol {
    // A tile was dragged, check if matches target
    
    func tileView(tileView: QRTile, didDragToPoint point: CGPoint) {
        var targetView: QRTileTarget?
        for tv in targets {
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








