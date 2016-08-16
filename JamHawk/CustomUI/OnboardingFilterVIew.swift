//
//  OnboardingFilterVIew.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/16/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class OnboardingFilterView: UIView {
	
	override func drawRect(rect: CGRect) {
		let contextRef = UIGraphicsGetCurrentContext()
		UIColor(white: 0, alpha: 0.5).setFill()
		CGContextFillEllipseInRect(contextRef, rect)
	}
}
