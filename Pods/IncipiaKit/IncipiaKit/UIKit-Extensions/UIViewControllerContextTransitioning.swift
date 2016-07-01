//
//  UIViewControllerContextTransitioning.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension UIViewControllerContextTransitioning
{
	public var toViewController: UIViewController? {
		return viewControllerForKey(UITransitionContextToViewControllerKey)
	}
	
	public var fromViewController: UIViewController? {
		return viewControllerForKey(UITransitionContextFromViewControllerKey)
	}
}
