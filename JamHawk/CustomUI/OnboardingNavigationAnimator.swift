//
//  OnboardingNavigationAnimator.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class OnboardingNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	var reverse: Bool = false
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.3
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		let containerView = transitionContext.containerView()
		guard let toView = transitionContext.toViewController?.view else { return }
		guard let fromView = transitionContext.fromViewController?.view else { return }
		let direction: CGFloat = reverse ? -1 : 1
		let const: CGFloat = -0.004
		
		toView.layer.anchorPoint = CGPointMake(direction == 1 ? 0 : 1, 0.5)
		fromView.layer.anchorPoint = CGPointMake(direction == 1 ? 1 : 0, 0.5)

		var viewFromTransform: CATransform3D = CATransform3DMakeRotation(direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
		var viewToTransform: CATransform3D = CATransform3DMakeRotation(-direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
		viewFromTransform.m34 = const
		viewToTransform.m34 = const
		
		containerView!.transform = CGAffineTransformMakeTranslation(direction * containerView!.frame.size.width / 2.0, 0)
		toView.layer.transform = viewToTransform
		containerView!.addSubview(toView)
		
		UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
			containerView!.transform = CGAffineTransformMakeTranslation(-direction * containerView!.frame.size.width / 2.0, 0)
			fromView.layer.transform = viewFromTransform
			toView.layer.transform = CATransform3DIdentity
			}, completion: {
				finished in
				containerView!.transform = CGAffineTransformIdentity
				fromView.layer.transform = CATransform3DIdentity
				toView.layer.transform = CATransform3DIdentity
				fromView.layer.anchorPoint = CGPointMake(0.5, 0.5)
				toView.layer.anchorPoint = CGPointMake(0.5, 0.5)
    
				if (transitionContext.transitionWasCancelled()) {
					toView.removeFromSuperview()
				} else {
					fromView.removeFromSuperview()
				}
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
		})
	}
}
