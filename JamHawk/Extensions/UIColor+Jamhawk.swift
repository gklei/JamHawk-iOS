//
//  UIColor+Jamhawk.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension UIColor {
	class func jmhLightGrayColor() -> UIColor {
		return UIColor(red: 228.0 / 255.0, green: 228.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)
	}
	
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
	
	class func jmhVeryLightGreyColor() -> UIColor {
		return UIColor(white: 228.0 / 255.0, alpha: 1.0)
	}
}

extension UIButton {
	class func jamhawkUserProfileButton(withTarget target: AnyObject?, selector: Selector) -> UIButton {
		
		let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
		profileButton.setImage(UIImage(named: "headphones"), forState: .Normal)
		profileButton.backgroundColor = UIColor.jmhTurquoiseColor()
		profileButton.tintColor = UIColor.whiteColor()
		profileButton.layer.cornerRadius = 12.0
		profileButton.layer.borderColor = UIColor.jmhLightGrayColor().CGColor
		profileButton.layer.borderWidth = 2
		
		profileButton.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
		return profileButton
	}
}