//
//  OnboardingCompletionViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/17/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class OnboardingCompletionViewController: UIViewController {
	
	@IBOutlet private var _signUpButton: UIButton!
	
	var backClosure: () -> Void = {}
	var signUpButtonClosure: () -> Void = {}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		backClosure = {
			self.navigationController?.popViewControllerAnimated(true)
		}
		
		_signUpButton.layer.cornerRadius = 2.0
		_signUpButton.layer.borderWidth = 2.0
		_signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
		
		let attrs: [String : AnyObject] = [
			NSFontAttributeName : UIFont(name: "OpenSans-Semibold", size: 14)!,
			NSForegroundColorAttributeName : UIColor.whiteColor()
		]
		
		let highlightedAttrs: [String : AnyObject] = [
			NSFontAttributeName : UIFont(name: "OpenSans-Semibold", size: 14)!,
			NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)
		]
		
		let normalAttrTitle = NSAttributedString(string: "Sign up with Email", attributes: attrs)
		let highlightedAttrTitle = NSAttributedString(string: "Sign up with Email", attributes: highlightedAttrs)
		
		_signUpButton.setAttributedTitle(normalAttrTitle, forState: .Normal)
		_signUpButton.setAttributedTitle(highlightedAttrTitle, forState: .Highlighted)
		_signUpButton.setBackgroundImage(UIImage.imageWithColor(UIColor(white: 1, alpha: 0.2)), forState: .Highlighted)
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
}
