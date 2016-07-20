//
//  JHSignUpViewController.swift
//  JamHawk
//
//  Created by Brendan Lau on 7/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import IncipiaKit

class JHSignUpViewController: UIViewController {

   // MARK: - IBOutlets
   @IBOutlet private var _containerView: UIView!
   @IBOutlet private var _centerYConstraint: NSLayoutConstraint!
   
   @IBOutlet private var _signUpLabel: UILabel!
   @IBOutlet private var _emailTextField: JHSignInSignUpTextField!
   @IBOutlet private var _passwordTextField: JHSignInSignUpTextField!
   @IBOutlet private var _confirmPasswordTextField: JHSignInSignUpTextField!
   
   // MARK: - Properties
   var session: JamHawkSession?
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
        super.viewDidLoad()
        _setupOutlets()
    }
   
   override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
      _centerYConstraint.constant = UIScreen.mainScreen().bounds.height * -0.1
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
   
   // MARK: - Class Methods
   // test credentials: brendan@incipia.co / hello1
   @IBAction func _continueButtonDidPress(sender: AnyObject) {
      guard let inputEmail = _emailTextField.text else { return }
      guard let inputPassword = _passwordTextField.text else { return }
      
      if _credentialsAreValid() {
         session!.signUp(email: inputEmail, password: inputPassword, callback: { (error, output) in
            if let error = error {
               self.present(error)
            } else {
               guard let output = output else { return }
               
               if output.success == true {
                  self.presentMessage("Success logging up")
               } else {
                  self.presentMessage(output.message ?? "Failure logging up")
               }
            }
         })
      }
   }
   
   // MARK: - Private Methods
   private func _passwordsMatch() -> Bool {
      guard let password = _passwordTextField.text?.trimmed where password != "" else { return false }
      guard let confirmedPassword = _confirmPasswordTextField.text?.trimmed where confirmedPassword != "" else { return false }
      return password == confirmedPassword
   }
   
   private func _credentialsAreValid() -> Bool {
      guard _emailTextField.text.isValidEmail else {
         presentMessage("Invalid email")
         return false
      }
      if !_passwordsMatch() {
         presentMessage("passwords do not match")
      }
      return _passwordsMatch()
   }
}
