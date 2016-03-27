//
//  FlipTransition.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/25/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.

//
import UIKit

protocol FlipTransitionProtocol {
    func flipViewForTransition (transition: FlipTransition) -> UIView?
}

@objc
protocol FlipTransitionCVProtocol {
    func transitionCollectionView() -> UICollectionView!
    func getSelectedIndexPath() -> NSIndexPath!
}

@objc protocol FlipTransitionCellProtocol{
    func transitionViewForCell() -> UIView!
}

//@objc protocol FlipPageViewControllerProtocol : FlipTransitionCVProtocol{
//    func pageViewCellScrollViewContentOffset() -> CGPoint
//}

private let FlipTransitionDuration: NSTimeInterval = 0.6

private let FlipTransitionZoomedScale: CGFloat = 15
private let FlipTransitionBackgroundScale: CGFloat = 0.80
let animationScale = UIScreen.mainScreen().bounds.size.width/300 // screenWidth / the width of waterfall collection view's grid


class FlipTransition: NSObject, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning {

    enum TransitionState {
        case Initial
        case Final
    }
    
    typealias ZoomingViews = (coloredView: UIView, imageView: UIView)

    var operation: UINavigationControllerOperation = .None

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // protocol needs to be @objc for conformance testing
        if fromVC is FlipTransitionProtocol &&
            toVC is FlipTransitionProtocol {
                self.operation = operation
                return self
        }
        else {
            return nil
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return FlipTransitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
        // Duration of transition as NSTimeInterval
        let duration = transitionDuration(transitionContext)
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        let collectionView = (fromViewController as! FlipTransitionCVProtocol).transitionCollectionView()
        
        containerView!.addSubview(fromViewController.view)
        containerView!.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        
        let indexPath = (fromViewController as! FlipTransitionCVProtocol).getSelectedIndexPath()
        let levelViewCell = collectionView.cellForItemAtIndexPath(indexPath)

        let leftUpperPoint = levelViewCell!.convertPoint(CGPointZero, toView: toViewController.view)
        
        
        let proxyView = (levelViewCell as! FlipTransitionCellProtocol).transitionViewForCell()
        let initialProxyViewFrame = proxyView.frame
        proxyView.hidden = true
        
        if self.operation == .Push {
            fromViewController.view.addSubview(proxyView)

            UIView.animateWithDuration(
                duration,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: [],
                animations: {
                    proxyView.hidden = false
                    proxyView.frame = toViewController.view.frame
                }, completion: {
                    (finished) in
                    proxyView.hidden = true
                    toViewController.view.alpha = 1
                    UIView.transitionFromView(
                        fromViewController.view,
                        toView: toViewController.view!,
                        duration: self.transitionDuration(transitionContext),
                        options: UIViewAnimationOptions.TransitionFlipFromRight) { finished in
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    }
            })
        } else {
            toViewController.view.alpha = 1
            proxyView.hidden = false
            proxyView.frame = containerView!.frame
            toViewController.view.addSubview(proxyView)
            UIView.transitionFromView(
                fromViewController.view,
                toView: toViewController.view,
                duration: self.transitionDuration(transitionContext),
                options: UIViewAnimationOptions.TransitionFlipFromLeft) { finished in
                    UIView.animateWithDuration(
                        duration,
                        delay: 0,
                        usingSpringWithDamping: 1,
                        initialSpringVelocity: 0,
                        options: [],
                        animations: {
                            proxyView.frame = initialProxyViewFrame
                        }, completion: {
                            (finished) in
                            proxyView.removeFromSuperview()
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    })
                    
            }
        }
        
        
    }
    
    
    
    

    
}