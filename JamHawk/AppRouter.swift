//
//  AppRouter.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import UIKit

class AppRouter {
	let window: UIWindow
	let session: JamHawkSession
	
	let rootNavController = JamHawkNavigationController()
	
	init(window: UIWindow, session: JamHawkSession) {
		self.window = window
		self.session = session
		
		let signInVC = SignInViewController.instantiate(.SignIn)
		signInVC.signUpButtonPressed = _signUp
		signInVC.signInButtonPressed = _signIn
		
		_setupWindow(withRootVC: signInVC)
	}
	
	private func _setupWindow(withRootVC rootVC: UIViewController) {
		rootNavController.viewControllers = [rootVC]
		window.rootViewController = rootNavController
		window.makeKeyAndVisible()
	}
}

extension AppRouter {
	private func _signUp(email: String, password: String) {
		print("sign UP! \(email), \(password)")
	}
	
	private func _signIn(email: String, password: String) {
		print("sign IN! \(email), \(password)")
	}
}
