//
//  SignInViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/19/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import IncipiaKit

class SignInViewController: UIViewController {
   
   // MARK: - IBOutlets
   @IBOutlet private var containerView: UIView!
   @IBOutlet private var centerYConstraint: NSLayoutConstraint!
   
   @IBOutlet private var signInLabel: UILabel!
   @IBOutlet private var forgotPasswordButton: UIButton!
   
   @IBOutlet private var emailTextField: JHSignInSignUpTextField!
   @IBOutlet private var passwordTextField: JHSignInSignUpTextField!
	
	var emailText: String {
		return emailTextField.text ?? ""
	}
	
	var passwordText: String {
		return passwordTextField.text ?? ""
	}
   
   // MARK: - Properties
	var backClosure: () -> Void = {}
	var continueClosure: () -> Void = {}
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      _setupOutlets()
		
		backClosure = {
			self.navigationController?.popViewControllerAnimated(true)
		}
   }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let backSel = #selector(SignInViewController.backItemPressed)
		let continueSel = #selector(SignInViewController.continueItemPressed)
		
		updateLeftBarButtonItem(withTitle: "   Back", action: backSel)
		updateRightBarButtonItem(withTitle: "Continue   ", action: continueSel)
	}
	
	internal func continueItemPressed() {
		continueClosure()
	}
	
	internal func backItemPressed() {
		backClosure()
	}
   
   // MARK: - Setup
	private func _setupOutlets() {
		signInLabel.kerning = 1.7
		centerYConstraint.constant = UIScreen.mainScreen().bounds.height * -0.1
   }
   
   // MARK: - Actions
   @IBAction private func _viewTapped(recognizer: UIGestureRecognizer) {
      view.endEditing(true)
   }
}

extension SignInViewController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		switch textField {
		case emailTextField:
			passwordTextField.becomeFirstResponder()
			return false
		case passwordTextField:
			passwordTextField.resignFirstResponder()
			return true
		default: return true
		}
	}
}
