//
//  UIColor+Jamhawk.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension UIColor {
	class func jmhTurquoiseColor() -> UIColor {
		return UIColor(red: 1.0 / 255.0, green: 187.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0)
	}
	
	class func jmhTangerineColor() -> UIColor {
		return UIColor(red: 248.0 / 255.0, green: 135.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
	}
	
	class func jmhStrawberryColor() -> UIColor {
		return UIColor(red: 248.0 / 255.0, green: 46.0 / 255.0, blue: 62.0 / 255.0, alpha: 1.0)
	}
	
	class func jmhWarmGreyColor() -> UIColor {
		return UIColor(white: 161.0 / 255.0, alpha: 1.0)
	}
	
	class func jmhLightGrayColor() -> UIColor {
		return UIColor(white: 228.0 / 255.0, alpha: 1.0)
	}
	
	class func jmhVeryLightGrayColor() -> UIColor {
		return UIColor(white: 248.0 / 255.0, alpha: 1.0)
	}
}

extension UIButton {
	class func jamhawkUserProfileButton(withTarget target: AnyObject?, selector: Selector) -> UIButton {
		let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
		profileButton.setImage(UIImage(named: "headphones"), forState: .Normal)
		profileButton.layer.backgroundColor = UIColor.jmhTurquoiseColor().CGColor
		profileButton.tintColor = UIColor.whiteColor()
		profileButton.layer.cornerRadius = 13.0
		profileButton.layer.borderColor = UIColor.jmhLightGrayColor().CGColor
		profileButton.layer.borderWidth = 2
		
		profileButton.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
		return profileButton
	}
}

class UserProfileButtonView: UIButton {
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let image = UIImage(named: "headphones")
	
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