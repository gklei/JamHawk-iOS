//
//  UIViewController+Extensions.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/17/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension UIViewController {
	func transition(from fromChildVC: UIViewController?, to toChildVC: UIViewController, usingContainer container: UIView, completion: dispatch_block_t? = nil) {
		
		fromChildVC?.willMoveToParentViewController(nil)
		addChildViewController(toChildVC)
		
		container.addAndFill(subview: toChildVC.view)
		toChildVC.view.alpha = 0
		toChildVC.view.layoutIfNeeded()
		
		UIView.animateWithDuration(0.2, animations: {
			toChildVC.view.alpha = 1
			fromChildVC?.view.alpha = 0
		}) { completed in
			fromChildVC?.view.removeFromSuperview()
			fromChildVC?.removeFromParentViewController()
			fromChildVC?.didMoveToParentViewController(nil)
			
			completion?()
		}
	}
	
	func add(childViewController vc: UIViewController, toContainer container: UIView) {
		addChildViewController(vc)
		
		let subview = vc.view
		container.addAndFill(subview: subview)
		vc.didMoveToParentViewController(self)
	}
}
