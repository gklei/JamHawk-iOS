//
//  UIView+Extensions.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/17/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension UIView {
	func addAndFill(subview subview: UIView) {
		addSubview(subview)
		
		subview.translatesAutoresizingMaskIntoConstraints = false
		subview.topAnchor.constraintEqualToAnchor(topAnchor).active = true
		subview.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
		subview.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
		subview.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
	}
}