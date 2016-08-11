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
   var session: JamHawkSession?
   
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
      signInLabel.kerning = 1.7
      passwordTextField.secureTextEntry = true
   }
   
   // MARK: - Actions
   @IBAction private func _viewTapped(recognizer: UIGestureRecognizer) {
      view.endEditing(true)
   }
   
   // MARK: - Class Methods
	
   @IBAction func continueButtonPressed(sender: AnyObject) {
      guard let email = emailTextField.text else { return }
      guard let password = passwordTextField.text else { return }
      
      if (_emailAndPasswordAreValid(email, password: password)) {
         session!.signIn(email: email, password: password, callback: { (error, output) in
            if let error = error  {
              self.present(error)
            } else {
               guard let output = output else { return }
               
               if output.success == true {
                  self.presentMessage("Success logging in")
               } else {
                  self.presentMessage(output.message ?? "Failure logging in")
               }
            }
         })
      }
   }
   
   private func _emailAndPasswordAreValid(email: String, password: String) -> Bool {
      if email == "" || !email.isValidEmail || password == "" { return false }
      return true
   }
}
