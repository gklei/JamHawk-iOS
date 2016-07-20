//
//  UIView+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

public extension UIView {
	public func addAndFill(subview subview: UIView) {
		addSubview(subview)
		subview.translatesAutoresizingMaskIntoConstraints = false
		subview.topAnchor.constraintEqualToAnchor(topAnchor).active = true
		subview.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
		subview.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
		subview.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
	}
}
