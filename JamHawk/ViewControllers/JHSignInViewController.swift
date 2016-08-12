//
//  JHSignInViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/19/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import IncipiaKit

class JHSignInViewController: UIViewController {
   
   // MARK: - IBOutlets
   @IBOutlet private var containerView: UIView!
   @IBOutlet private var centerYConstraint: NSLayoutConstraint!
   
   @IBOutlet private var signInLabel: UILabel!
   @IBOutlet private var forgotPasswordButton: UIButton!
   
   @IBOutlet private var emailTextField: JHSignInSignUpTextField!
   @IBOutlet private var passwordTextField: JHSignInSignUpTextField!
   
   // MARK: - Properties
	var backClosure: () -> Void = {}
	var continueClosure: () -> Void = {}
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
		centerYConstraint.constant = UIScreen.mainScreen().bounds.height * -0.1
      _setupOutlets()
		
		backClosure = {
			self.navigationController?.popViewControllerAnimated(true)
		}
   }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let backSel = #selector(JHSignInViewController.backItemPressed)
		let continueSel = #selector(JHSignInViewController.continueItemPressed)
		
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
   }
   
   // MARK: - Actions
   @IBAction private func _viewTapped(recognizer: UIGestureRecognizer) {
      view.endEditing(true)
   }
}
