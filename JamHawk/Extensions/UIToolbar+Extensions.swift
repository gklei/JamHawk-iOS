//
//  UIToolbar+Extensions.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/12/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension UIToolbar {
	func update(backgroundColor color: UIColor) {
		let image = UIImage.imageWithColor(color)
		setBackgroundImage(image, forToolbarPosition: .Any, barMetrics: .Default)
	}
	
	func makeShadowTransparent() {
		setShadowImage(UIImage(), forToolbarPosition: .Any)
	}
}
