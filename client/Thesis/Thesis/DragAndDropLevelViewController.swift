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
        let image: UIImage = cropImage(UIImage(named: "qr")!)
        let tileView = QRTile(sideLength: 100, id: 2, image: image)
        tileView.center = CGPointMake(500, 500)
        tileView.dragDelegate = self
        self.view.addSubview(tileView)
    
    }
    
    
    
    func cropImage(qr: UIImage) -> UIImage {
        let imgSize = qr.size
        
        let crop = CGRectMake(0, 0, imgSize.width / 5, imgSize.height / 5)
        
        let cgImage = CGImageCreateWithImageInRect(qr.CGImage, crop)
        let image: UIImage = UIImage(CGImage: cgImage!)
        
        return image

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








