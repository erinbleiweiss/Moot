//
//  FlipTransition.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/25/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.

//
import UIKit

@objc
protocol FlipTransitionCVProtocol {
    func transitionCollectionView() -> UICollectionView!
}

protocol FlipTransitionProtocol {
    func flipViewForTransition () -> UIView?
}

@objc protocol FlipTransitionCellProtocol{
    func snapshotForTransition() -> UIView!
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
        let duration = transitionDuration(transitionContext)
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        let toView = toViewController.view
        toView.hidden = true
        
        let transitionView = (toViewController as! FlipTransitionProtocol).flipViewForTransition()
        let pageView = (fromViewController as! FlipTransitionCVProtocol).transitionCollectionView()
        transitionView?.layoutIfNeeded()
        let indexPath = pageView.fromPageIndexPath()
        let levelViewCell = pageView.cellForItemAtIndexPath(indexPath)

        let leftUpperPoint = levelViewCell!.convertPoint(CGPointZero, toView: toViewController.view)
        
        let snapshot = (levelViewCell as! FlipTransitionCellProtocol).snapshotForTransition()
        snapshot!.transform = CGAffineTransformMakeScale(animationScale, animationScale)
        snapshot!.origin(CGPointMake(0, 0))
        containerView?.addSubview(snapshot!)
        
        toView.hidden = false
        toView.alpha = 0
        toView.transform = (snapshot?.transform)!
        toView.frame = CGRectMake(-(leftUpperPoint.x * animationScale), -(leftUpperPoint.y * animationScale), toView.frame.size.width, toView.frame.size.height)
        let whiteViewContainer = UIView(frame: UIScreen.mainScreen().bounds)
        containerView?.addSubview(snapshot!)
        containerView?.insertSubview(whiteViewContainer, belowSubview: toView)
        
        UIView.animateWithDuration(duration, animations: {
            snapshot!.transform = CGAffineTransformIdentity
            snapshot!.frame = CGRectMake(leftUpperPoint.x, leftUpperPoint.y, snapshot!.frame.size.width, snapshot!.frame.size.height)
            toView.transform = CGAffineTransformIdentity
            toView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
            toView.alpha = 1
            }, completion:{finished in
                if finished {
                    snapshot!.removeFromSuperview()
                    whiteViewContainer.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
        })
        
        
//        var backgroundViewController = fromViewController
//        var foregroundViewController = toViewController
//        
//        if operation == .Pop {
//            backgroundViewController = toViewController
//            foregroundViewController = fromViewController
//        }
//        
//        // get the colored view in the background and foreground view controllers
//        
//        let backgroundColoredViewMaybe = (backgroundViewController as? FlipIconViewController)?.flipIconColoredViewForTransition(self)
//        let foregroundColoredViewMaybe = (foregroundViewController as? FlipIconViewController)?.flipIconColoredViewForTransition(self)
//        
//        assert(backgroundColoredViewMaybe != nil, "Cannot find colored view in background view controller")
//        assert(foregroundColoredViewMaybe != nil, "Cannot find colored view in foreground view controller")
//        
//        let backgroundColoredView = backgroundColoredViewMaybe!
//        let foregroundColoredView = foregroundColoredViewMaybe!
//        
//        // zoom foreground view
//        let fullscreenWidth = foregroundViewController.view.frame.width
//        let fullscreenHeight = foregroundViewController.view.frame.height
//        let fullscreen = CGRectMake(0, 0, fullscreenWidth, fullscreenHeight)
//        var proxyView: UIView = UIView(frame: fullscreen)
//        proxyView.hidden = true
//        proxyView.autoresizingMask = fromViewController.view.autoresizingMask
//        fromViewController.view.superview?.addSubview(proxyView)
//        
//        
//        // perform animation
//        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
//            [self]
//            self.CGAffineTransformFromRect(fromViewController.view.frame, toRect: fullscreen)
//            }, completion: {
//                (finished) in
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//        })
        
    }
    
    
        
//        // create view snapshots
//        
//        // view controller need to be in view hierarchy for snapshotting
//        containerView!.addSubview(backgroundViewController.view)
//        let snapshotOfColoredView = backgroundColoredView.snapshotViewAfterScreenUpdates(false)
//        snapshotOfColoredView.contentMode = .ScaleAspectFit
//        
//        // setup animation
//        containerView!.addSubview(fromViewController.view)
//        containerView!.addSubview(toViewController.view)
//        toViewController.view.alpha = 0
//        
//        // perform animation
//        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
//            [self]
//            toViewController.view.alpha = 1
//            }, completion: {
//                (finished) in
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//        })
//        
//    }

        
    func CGAffineTransformFromRect(sourceRect: CGRect, toRect finalRect:CGRect) -> CGAffineTransform {
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, -(CGRectGetMidX(sourceRect) - CGRectGetMidX(finalRect)), -(CGRectGetMidY(sourceRect) - CGRectGetMidY(finalRect)))
        transform = CGAffineTransformScale(transform, finalRect.size.width / sourceRect.size.width, finalRect.size.height / sourceRect.size.height)
        return transform
    }
    
}