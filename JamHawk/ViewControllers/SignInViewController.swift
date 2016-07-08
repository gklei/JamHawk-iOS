//
//  ViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import IncipiaKit

class SignInViewController: UIViewController
{
	@IBOutlet private var _emailTextField: BottomBorderTextField!
	@IBOutlet private var _passwordTextField: BottomBorderTextField!
	
	var emailText: String {
		return _emailTextField.text ?? ""
	}
	
	var passwordText: String {
		return _passwordTextField.text ?? ""
	}
	
	var signInButtonPressed: (email: String, password: String) -> Void = { _, _ in }
	var signUpButtonPressed: (email: String, password: String) -> Void = { _, _ in }

	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_emailTextField.update(placeHolderColor: UIColor(white: 1, alpha: 0.75))
		_passwordTextField.update(placeHolderColor: UIColor(white: 1, alpha: 0.75))
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	// MARK: - Actions
	@IBAction func _viewTapped(recognizer: UITapGestureRecognizer) {
		view.endEditing(true)
	}
	
	@IBAction private func _signInButtonPressed() {
		signInButtonPressed(email: emailText, password: passwordText)
	}
	
	@IBAction private func _signUpButtonPressed() {
		signUpButtonPressed(email: emailText, password: passwordText)
	}
}
