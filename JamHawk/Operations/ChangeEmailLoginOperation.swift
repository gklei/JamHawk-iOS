//
//  ChangeEmailLoginOperation.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/30/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import SwiftSpinner

class ChangeEmailLoginOperation: BaseOperation {
	
	private let _currentEmail: String
	private let _session: JamHawkSession
	private let _presentationContext: UIViewController
	
	private var _emailTextField: UITextField?
	private var _passwordTextField: UITextField?
	
	init(currentEmail: String, session: JamHawkSession, presentationContext: UIViewController) {
		_currentEmail = currentEmail
		_session = session
		_presentationContext = presentationContext
	}
	
	override func execute() {
		let title = "Change Email"
		let message = "Enter the new email and your current password"
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		alertController.view.tintColor = UIColor.jmhTurquoiseColor()
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.textColor = .jmhWarmGreyColor()
			textField.placeholder = "New email"
			textField.returnKeyType = .Next
			
			self._emailTextField = textField
		}
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.textColor = .jmhWarmGreyColor()
			textField.secureTextEntry = true
			textField.placeholder = "Password"
			textField.returnKeyType = .Done
			
			self._passwordTextField = textField
		}
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
			alertController.view.endEditing(true)
			self.finish()
		}))
		
		let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
			alertController.view.endEditing(true)
			
			if let email = self._emailTextField?.text, password = self._passwordTextField?.text {
				self._requestLoginEmailReplacement(updatedEmail: email, password: password)
			} else {
				self.finish()
			}
		})
		alertController.addAction(okAction)
		alertController.preferredAction = okAction
		
		alertController.view.setNeedsLayout()
		
		dispatch_async(dispatch_get_main_queue()) {
			self._presentationContext.presentViewController(alertController, animated: true) {
				alertController.view.tintColor = .jmhTurquoiseColor()
			}
		}
	}
	
	private func _requestLoginEmailReplacement(updatedEmail email: String, password: String) {
		SwiftSpinner.show("Updating email address...")
		
		let creds = (email: _currentEmail, password: password)
		_session.changeEmail(toNewEmail: email, usingCredentials: creds) { (error, output) in
			SwiftSpinner.hide()
			
			if let error = error {
				self._presentationContext.present(error)
				self.finish()
				return
			}
			
			if let output = output {
				if output.success {
					JamhawkStorage.lastUsedCredentials = (email: email, password: password)
					self._presentationContext.presentMessage("Your email has been updated successfully.")
				} else {
					if let message = output.message {
						self._presentationContext.presentMessage(message)
					} else {
						self._presentationContext.presentMessage("There was a problem. Please try again.")
					}
				}
			}
			self.finish()
		}
	}
}
