//
//  PopAnimator.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 6/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import UIKit

class PopAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        transitionContext.containerView.insertSubview((toVC?.view)!, belowSubview: (fromVC?.view)!)
        fromVC?.view.alpha = 1
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC?.view.alpha = 0
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
