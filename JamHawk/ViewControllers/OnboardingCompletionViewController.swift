//
//  OnboardingCompletionViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/17/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class OnboardingCompletionViewController: UIViewController {
	
	@IBOutlet private var _signUpButton: WhiteRoundedJamhawkButton!
	
	var backClosure: () -> Void = {}
	var signUpButtonClosure: () -> Void = {}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		backClosure = {
			self.navigationController?.popViewControllerAnimated(true)
		}
		
		_signUpButton.update(title: "Sign Up With Email")
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let backSel = #selector(SignInViewController.backItemPressed)
		updateLeftBarButtonItem(withTitle: "   Back", action: backSel)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	internal func backItemPressed() {
		backClosure()
	}
	
	@IBAction private func _signUpButtonPressed() {
		signUpButtonClosure()
	}
	
	@IBAction private func _swipeRightRecognized() {
		backClosure()
	}
}
