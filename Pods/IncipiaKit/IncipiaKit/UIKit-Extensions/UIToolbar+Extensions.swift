//
//  UIToolbar+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/19/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension UIToolbar {
	public func update(backgroundColor color: UIColor) {
		let image = UIImage.imageWithColor(color)
		setBackgroundImage(image, forToolbarPosition: .Any, barMetrics: .Default)
	}
	
	public func makeTransparent() {
		setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
	}
	
	public func resetTransparency() {
		setBackgroundImage(nil, forToolbarPosition: .Any, barMetrics: .Default)
	}
	
	public func makeShadowTransparent() {
		setShadowImage(UIImage(), forToolbarPosition: .Any)
	}
}