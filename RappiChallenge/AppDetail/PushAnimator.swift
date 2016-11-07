//
//  PushAnimator.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 6/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//

import UIKit

protocol PushAnimatorView : class {
    func performPushAnimations(originFrame: CGRect, duration: TimeInterval)
}

class PushAnimator : NSObject, UIViewControllerAnimatedTransitioning {

    var originFrame = CGRect.zero
    var sharedView:UIView!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let targetVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        transitionContext.containerView.addSubview((targetVC?.view)!)
        
        targetVC!.view.alpha = 0
        let duration = transitionDuration(using: transitionContext)
        if let pushAnimationView = targetVC as? PushAnimatorView {
            // object conforms to protocol
            pushAnimationView.performPushAnimations(originFrame: originFrame, duration: duration)
        }
        //transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        UIView.animate(withDuration: duration, animations: {
            targetVC!.view.alpha = 1
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
