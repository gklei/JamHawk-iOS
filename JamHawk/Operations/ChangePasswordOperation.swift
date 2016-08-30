//
//  ChangePasswordOperation.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/30/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ChangePasswordOperation: BaseOperation {
	
	private let _currentPassword: String
	private let _newPassword: String
	private let _session: JamHawkSession
	private let _presentationContext: UIViewController
	
	init(currentPassword: String, newPassword: String, session: JamHawkSession, presentationContext: UIViewController) {
		_currentPassword = currentPassword
		_newPassword = newPassword
		_session = session
		_presentationContext = presentationContext
	}
	
	override func execute() {
		let alertController = UIAlertController(title: "Change Password", message: "Enter your current password and the new password", preferredStyle: .Alert)
		
		alertController.view.tintColor = UIColor.jmhTurquoiseColor()
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.borderStyle = .None
			textField.placeholder = "Current password"
		}
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.borderStyle = .None
			textField.placeholder = "New password"
		}
		
		alertController.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action) in
			self._presentationContext.view.endEditing(true)
			self.finish()
		}))
		
		_presentationContext.presentViewController(alertController, animated: true) {
			alertController.view.tintColor = .jmhTurquoiseColor()
		}
	}
}
