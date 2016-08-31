//
//  ResetPasswordOperation.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/30/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import SwiftSpinner

class ResetPasswordOperation: BaseOperation {
	
	private let _recoveryEmail: String?
	private let _session: JamHawkSession
	private let _presentationContext: UIViewController
	
	private var _recoveryEmailTextField: UITextField?
	
	init(recoveryEmail: String?, session: JamHawkSession, presentationContext: UIViewController) {
		_recoveryEmail = recoveryEmail
		_session = session
		_presentationContext = presentationContext
	}

	override func execute() {
		let title = "Reset Password"
		let message = "Enter the recovery email address for resetting the password"
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		
		alertController.view.tintColor = UIColor.jmhTurquoiseColor()
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.borderStyle = .None
			textField.placeholder = "Email address"
			textField.text = self._recoveryEmail
			textField.returnKeyType = .Next
			
			self._recoveryEmailTextField = textField
		}
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
			alertController.view.endEditing(true)
			self.finish()
		}))
		
		let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
			alertController.view.endEditing(true)
			
			if let email = self._recoveryEmailTextField?.text {
				self._sendResetPasswordEmail(toEmail: email)
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
	
	private func _sendResetPasswordEmail(toEmail email: String) {
		SwiftSpinner.show("Sending reset password email...")
		_session.sendResetPasswordEmail(toEmail: email) { (error, output) in
			SwiftSpinner.hide()
			
			if let error = error {
				self._presentationContext.present(error)
				self.finish()
				return
			}
			
			if let output = output {
				if output.success {
					self._presentationContext.presentMessage("An email for resetting your password was successfully sent.")
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
