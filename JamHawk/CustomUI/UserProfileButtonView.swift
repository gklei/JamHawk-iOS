//
//  UserProfileButtonView.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class UserProfileButtonView: UIButton {
	private let image = UIImage(named: "headphones")
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clearColor()
	}
	
	convenience init() {
		self.init(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
	}
	
	override func drawRect(rect: CGRect) {
		UIColor.jmhLightGrayColor().setFill()
		let context = UIGraphicsGetCurrentContext()
		CGContextFillEllipseInRect(context, rect)
		
		UIColor.jmhTurquoiseColor().setFill()
		CGContextFillEllipseInRect(context, rect.insetBy(dx: 2, dy: 2))
		
		if let imageSize = image?.size {
			var imageRect = CGRect(origin: CGPoint.zero, size: imageSize)
			imageRect.origin.x = rect.midX - imageSize.width * 0.5
			imageRect.origin.y = rect.midY - imageSize.height * 0.5
			image?.drawInRect(imageRect)
		}
	}
}