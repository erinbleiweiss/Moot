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
    
    private var tiles = [QRTile]()
    private var targets = [QRTileTarget]()
    
    
    var response: String!
    @IBOutlet weak var successLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller.level = 3

        let gameView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
        self.view.addSubview(gameView)
        self.controller.gameView = gameView
        
        self.controller.getQRCode(300, height: 300){ responseObject, error in
            let rows = 3
            let cols = 3
            let tileMargin = 10
            
//            let image: UIImage = UIImage(named: "qr2")!
            self.generateTiles(self.controller.QRImage, rows: rows, cols: cols)
            self.generateTargets(rows, cols: cols)
            
            self.tiles = self.tiles.shuffle()
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
                self.tiles.append(tile)
                id++
            }
        }
    
    }
    
    func displayTiles(tileMargin: Int, rows: Int, cols: Int){
        var idx = 0
        for row in 0...rows-1 {
            for col in 0...cols-1 {
                self.tiles[idx].center = CGPointMake(100 + CGFloat(col) * self.tiles[idx].frame.width
                    + (CGFloat(col) * CGFloat(tileMargin)),
                    500 + CGFloat(row) * self.tiles[idx].frame.height
                        + (CGFloat(row) * CGFloat(tileMargin)))
                self.tiles[idx].dragDelegate = self
                self.view.addSubview(self.tiles[idx])
                idx++
            }
        }
    }
    
    func generateTargets(rows: Int, cols: Int){
        
        let width = self.tiles[0].frame.width
        let height = self.tiles[0].frame.height
        
        var id = 0
        for row in 0...rows-1{
            for col in 0...cols-1{
                let frame = CGRect(x: 0, y: 0, width: width, height: height)
                let targetView = QRTileTarget(id: id, frame: frame)
                targetView.center = CGPointMake(100 + CGFloat(col) * width, 150 + CGFloat(row) * height)
                targetView.backgroundColor = UIColor(white: 1, alpha: 0.5)
                self.targets.append(targetView)
                self.view.addSubview(targetView)
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
    

    @IBAction func cancelToJigsawLevelViewController(segue:UIStoryboardSegue) {
        self.successLabel.text = response
    }

}

extension JigsawLevelViewController: TileDragDelegateProtocol {
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




    