//
//  UIStoryboard+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

public enum StoryboardType: String {
	case Onboarding, SignIn, SignUp, Profile, Main, Alerts
}

public extension UIStoryboard {
	public convenience init(type: StoryboardType) {
		self.init(name: type.rawValue, bundle: nil)
	}
}

public extension UIViewController {
	public static var className: String {
		// Get the name of current class
		let classString = NSStringFromClass(self)
		let components = classString.componentsSeparatedByString(".")
		assert(components.count > 0, "Failed extract class name from \(classString)")
		return components.last!
	}
	
	// These methods only work if the view controller's ID is the same as the class name
	public class func instantiate(type: StoryboardType) -> Self {
		let storyboard = UIStoryboard(type: type)
		return instantiateFromStoryboard(storyboard, type: self)
	}
	
	public class func instantiate(fromStoryboard name: String) -> Self {
		let storyboard = UIStoryboard(name: name, bundle: nil)
		return instantiateFromStoryboard(storyboard, type: self)
	}
	
	private class func instantiateFromStoryboard<T: UIViewController>(storyboard: UIStoryboard, type: T.Type) -> T {
		return storyboard.instantiateViewControllerWithIdentifier(self.className) as! T
	}
}