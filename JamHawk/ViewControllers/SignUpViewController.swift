//
//  SignUpViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import IncipiaKit

class SignUpViewController: UIViewController {

   // MARK: - IBOutlets
   @IBOutlet private var _containerView: UIView!
   @IBOutlet private var _centerYConstraint: NSLayoutConstraint!
   
   @IBOutlet private var _signUpLabel: UILabel!
   @IBOutlet private var _emailTextField: JHSignInSignUpTextField!
   @IBOutlet private var _passwordTextField: JHSignInSignUpTextField!
   @IBOutlet private var _confirmPasswordTextField: JHSignInSignUpTextField!
   
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
      _centerYConstraint.constant = UIScreen.mainScreen().bounds.height * -0.1
		
		let backSel = #selector(SignUpViewController.backItemPressed)
		let continueSel = #selector(SignUpViewController.continueItemPressed)
		
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
      _signUpLabel.kerning = 1.7
      _passwordTextField.secureTextEntry = true
      _confirmPasswordTextField.secureTextEntry = true
   }
   
   // MARK: - Actions
   @IBAction func _viewTapped(sender: AnyObject) {
      view.endEditing(true)
   }
   
   // MARK: - Private Methods
   private func _passwordsMatch() -> Bool {
      guard let password = _passwordTextField.text?.trimmed where password != "" else { return false }
      guard let confirmedPassword = _confirmPasswordTextField.text?.trimmed where confirmedPassword != "" else { return false }
      return password == confirmedPassword
   }
   
   private func _credentialsAreValid() -> Bool {
      guard let email = _emailTextField.text where email.isValidEmail else { return false }
      return _passwordsMatch()
   }
}
