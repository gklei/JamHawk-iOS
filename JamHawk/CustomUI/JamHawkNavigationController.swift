//
//  JamHawkNavigationController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class JamHawkNavigationController: UINavigationController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		makeNavBarTransparent()
		makeNavBarShadowTransparent()
		
		navigationBar.titleTextAttributes = [
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont.boldSystemFontOfSize(13)
		]
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return topViewController?.preferredStatusBarStyle() ?? .LightContent
	}
}

class ProfileNavigationController: UINavigationController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		makeNavBarTransparent()
		
		navigationBar.titleTextAttributes = [
			NSForegroundColorAttributeName : UIColor(white: 129.0 / 255.0, alpha: 1),
			NSFontAttributeName : UIFont(name: "OpenSans", size: 14)!
		]
		
		let image = UIImage.imageWithColor(UIColor.jmhLightGrayColor())
		navigationBar.shadowImage = image
	}
}
