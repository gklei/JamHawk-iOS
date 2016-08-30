//
//  ChangeEmailLoginOperation.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/30/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ChangeEmailLoginOperation: BaseOperation {
	
	private let _currentEmail: String
	private let _newEmail: String
	private let _password: String
	private let _session: JamHawkSession
	private let _presentationContext: UIViewController

	init(currentEmail: String, newEmail: String, password: String, session: JamHawkSession, presentationContext: UIViewController) {
		_currentEmail = currentEmail
		_newEmail = newEmail
		_password = password
		_session = session
		_presentationContext = presentationContext
	}
	
	override func execute() {
		let alertController = UIAlertController(title: "Change Email", message: "Enter the new email and your current password", preferredStyle: .Alert)
		
		alertController.view.tintColor = UIColor.jmhTurquoiseColor()
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.borderStyle = .None
			textField.placeholder = "New email"
		}
		
		alertController.addTextFieldWithConfigurationHandler { (textField) in
			textField.borderStyle = .None
			textField.placeholder = "Password"
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
