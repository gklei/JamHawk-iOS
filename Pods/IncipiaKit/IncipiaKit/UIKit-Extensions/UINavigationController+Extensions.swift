//
//  UINavigationController+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension UINavigationController
{
	override public func makeNavBarTransparent() {
		navigationBar.makeTransparent()
	}
	
	override public func resetNavBarTransparency() {
		navigationBar.resetTransparency()
	}
	
	override public func makeNavBarShadowTransparent() {
		navigationBar.shadowImage = UIImage()
	}
}
