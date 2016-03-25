//
//  FlipTransition.swift
//  Thesis
//
//  Created by Erin Bleiweiss on 3/25/16.
//  Copyright © 2016 Erin Bleiweiss. All rights reserved.

//
import UIKit

@objc
protocol FlipIconViewController {
    func flipIconColoredViewForTransition(transition: FlipTransition) -> UIView?
}

private let FlipTransitionDuration: NSTimeInterval = 0.6

class FlipTransition: NSObject, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // protocol needs to be @objc for conformance testing
        if fromVC is FlipIconViewController &&
            toVC is FlipIconViewController {
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
        
        // setup animation
        containerView!.addSubview(fromViewController.view)
        containerView!.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        
        // perform animation
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            [self]
            toViewController.view.alpha = 1
            }, completion: {
                (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
        
    }
}