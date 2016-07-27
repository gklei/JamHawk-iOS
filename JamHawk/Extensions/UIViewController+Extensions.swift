//
//  UIViewController+Extensions.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/17/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol PlayerStoryboardInstantiable {
	static func create() -> Self
}

extension PlayerStoryboardInstantiable where Self: UIViewController {
	static func create() -> Self {
		return instantiate(fromStoryboard: "Player")
	}
}

extension UIViewController {
	func transition(from fromChildVC: UIViewController?, to toChildVC: UIViewController, usingContainer container: UIView, completion: dispatch_block_t? = nil) {
		
		fromChildVC?.willMoveToParentViewController(nil)
		addChildViewController(toChildVC)
		
		container.addAndFill(subview: toChildVC.view)
		toChildVC.view.alpha = 0
		toChildVC.view.layoutIfNeeded()
		
		UIView.animateWithDuration(0.3, animations: {
			toChildVC.view.alpha = 1
			fromChildVC?.view.alpha = 0
		}) { completed in
			fromChildVC?.view.removeFromSuperview()
			fromChildVC?.removeFromParentViewController()
			fromChildVC?.didMoveToParentViewController(nil)
			
			completion?()
		}
	}
	
	func transition(from fromChildVC: UIViewController?, to toChildVC: UIViewController, completion: dispatch_block_t? = nil) {
		
		guard let container = fromChildVC?.view.superview else { return }
		
		fromChildVC?.willMoveToParentViewController(nil)
		addChildViewController(toChildVC)
		
		container.addAndFill(subview: toChildVC.view)
		toChildVC.view.alpha = 0
		toChildVC.view.layoutIfNeeded()
		
		UIView.animateWithDuration(0.3, animations: {
			toChildVC.view.alpha = 1
			fromChildVC?.view.alpha = 0
		}) { completed in
			fromChildVC?.view.removeFromSuperview()
			fromChildVC?.removeFromParentViewController()
			fromChildVC?.didMoveToParentViewController(nil)
			
			completion?()
		}
	}
}
