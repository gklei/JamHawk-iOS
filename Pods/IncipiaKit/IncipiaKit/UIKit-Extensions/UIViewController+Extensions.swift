//
//  UIViewController+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension UIViewController
{
	public func makeNavBarTransparent()
	{
		navigationController?.navigationBar.makeTransparent()
	}
	
	public func makeNavBarShadowTransparent()
	{
		navigationController?.navigationBar.shadowImage = UIImage()
	}
	
	public func resetNavBarTransparency()
	{
		navigationController?.navigationBar.resetTransparency()
	}
	
	public func resetNavBarShadow()
	{
		navigationController?.navigationBar.shadowImage = nil
	}
	
	public func updateNavBar(withColor color: UIColor)
	{
		let image = UIImage.imageWithColor(color)
		navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: .Default)
	}
	
	public func updateNavBarTintWithColor(color: UIColor)
	{
		navigationController?.navigationBar.tintColor = color
		navigationController?.navigationBar.barTintColor = color
	}
	
	func add(childViewController vc: UIViewController, toContainer container: UIView) {
		addChildViewController(vc)
		container.addAndFill(subview: vc.view)
		vc.didMoveToParentViewController(self)
	}
}
