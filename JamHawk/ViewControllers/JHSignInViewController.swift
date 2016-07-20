//
//  JHSignInViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/19/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class JHSignInSignUpTextField: UITextField {
   override func textRectForBounds(bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: 20, dy: 0)
   }
   override func editingRectForBounds(bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: 20, dy: 0)
   }
}

class JHSignInViewController: UIViewController {
   
   // MARK: - IBOutlets
   @IBOutlet private var containerView: UIView!
   @IBOutlet private var centerYConstraint: NSLayoutConstraint!
   
   @IBOutlet private var signInLabel: UILabel!
   @IBOutlet private var forgotPasswordButton: UIButton!
   
   @IBOutlet private var emailTextField: JHSignInSignUpTextField!
   @IBOutlet private var passwordTextField: JHSignInSignUpTextField!
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      _setupOutlets()
   }
   
   override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
      centerYConstraint.constant = UIScreen.mainScreen().bounds.height * -0.1
   }
   
   // MARK: - Setup
   private func _setupOutlets() {
      signInLabel.text = "Sign In"
      signInLabel.kerning = 1.7
      passwordTextField.secureTextEntry = true
   }
   
   // MARK: - Actions
   @IBAction private func _viewTapped(recognizer: UIGestureRecognizer) {
      view.endEditing(true)
   }
}
