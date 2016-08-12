//
//  WelcomeViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/12/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
	
	var signUpClosure: () -> Void = {}
	var getStartedClosure: () -> Void = {}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	@IBAction private func _signUpButtonPressed() {
		signUpClosure()
	}
	
	@IBAction private func _getStartedButtonPressed() {
		getStartedClosure()
	}
}
