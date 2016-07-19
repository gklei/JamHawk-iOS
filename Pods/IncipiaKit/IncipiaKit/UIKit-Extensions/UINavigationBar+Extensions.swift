//
//  UINavigationBar+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension UINavigationBar
{
	public func makeTransparent() {
		setBackgroundImage(UIImage(), forBarMetrics: .Default)
	}
	
	public func resetTransparency() {
		setBackgroundImage(nil, forBarMetrics: .Default)
	}
	
	public func update(backgroundColor color: UIColor) {
		let image = UIImage.imageWithColor(color)
		setBackgroundImage(image, forBarMetrics: .Default)
	}
}
