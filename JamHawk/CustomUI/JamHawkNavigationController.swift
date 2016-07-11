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
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return topViewController?.preferredStatusBarStyle() ?? .LightContent
	}
}