//
//  ChangePasswordOperation.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/30/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import SwiftSpinner

class ChangePasswordOperation: BaseOperation {
	
	private let _currentEmail: String
	private let _session: JamHawkSession
	private let _presentationContext: UIViewController
	
	private var _currentPasswordTextField: UITextField?
	private var _newPasswordTextField: UITextField?
	
	init(currentEmail: String, session: JamHawkSession, presentationContext: UIViewController) {
		_currentEmail = currentEmail
		_session = session
		_presentationContext = presentationContext
	}
	
	override func execute() {
		let title = "Change Password"
		let message = "Enter your current password and the new password"
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		
		alertController.view.tintColor = UIColor.jmhTurquoiseColor()
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.borderStyle = .None
			textField.secureTextEntry = true
			textField.placeholder = "Current password"
			textField.returnKeyType = .Next
			
			self._currentPasswordTextField = textField
		}
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.borderStyle = .None
			textField.secureTextEntry = true
			textField.placeholder = "New password"
			textField.returnKeyType = .Done
			
			self._newPasswordTextField = textField
		}
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
			alertController.view.endEditing(true)
			self.finish()
		}))
		
		let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
			alertController.view.endEditing(true)
			
			if let currentPass = self._currentPasswordTextField?.text, newPass = self._newPasswordTextField?.text {
				self._requestPasswordUpdate(toNewPassword: newPass, currentPassword: currentPass)
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
	
	private func _requestPasswordUpdate(toNewPassword password: String, currentPassword: String) {
		SwiftSpinner.show("Updating password...")
		
		let creds = (email: _currentEmail, password: currentPassword)
		_session.changePassword(toNewPassword: password, usingCredentials: creds) { (error, output) in
			SwiftSpinner.hide()
			
			if let error = error {
				self._presentationContext.present(error)
				self.finish()
				return
			}
			
			if let output = output {
				if output.success {
					JamhawkStorage.lastUsedCredentials = (email: self._currentEmail, password: password)
					self._presentationContext.presentMessage("Your password has been updated successfully.")
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
