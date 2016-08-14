//
//  AppRouter.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class AppRouter {
	let window: UIWindow
	let session: JamHawkSession
	private var _coordinationController: SystemCoordinationController?
	
	let rootNavController = JamHawkNavigationController()
	
	private let _mainPlayerVC = MainPlayerViewController.create()
	private let _welcomeVC = WelcomeViewController.instantiate(fromStoryboard: "SignIn")
	private let _signInVC = JHSignInViewController.instantiate(fromStoryboard: "SignIn")
	
	init(window: UIWindow, session: JamHawkSession) {
		self.window = window
		self.session = session
		
		_coordinationController = SystemCoordinationController(apiService: session)
		
		_mainPlayerVC.setupSystems(withCoordinationController: _coordinationController!)
		
		_welcomeVC.signUpClosure = _showSignInUI
		_welcomeVC.getStartedClosure = _showGetStartedUI
		_signInVC.continueClosure = _trySignIn
		
		_setupWindow(withRootVC: _welcomeVC)
	}
	
	private func _setupWindow(withRootVC rootVC: UIViewController) {
		rootNavController.viewControllers = [rootVC]
		window.rootViewController = rootNavController
		window.makeKeyAndVisible()
	}
}

// MARK: - Signing In & Up
extension AppRouter {
	
	private func _showSignInUI() {
		rootNavController.pushViewController(_signInVC, animated: true)
	}
	
	private func _showGetStartedUI() {
		session.signInWithTestCreds { (error, output) in
			self._handleUserAccessCallback(error, output: output, context: self._welcomeVC)
		}
	}
	
	@objc internal func popNavigationStack() {
		rootNavController.popViewControllerAnimated(true)
	}
	
	private func _trySignIn() {
	}
	
	private func _signUp(email: String, password: String, context: UIViewController) {
		if email == "" && password == "" {
			session.signInWithTestCreds { (error, output) in
				self._handleUserAccessCallback(error, output: output, context: context)
			}
		} else {
			session.signUp(email: email, password: password) { (error, output) in
				self._handleUserAccessCallback(error, output: output, context: context)
			}
		}
	}
	
	private func _signIn(email: String, password: String, context: UIViewController) {
		if email == "" && password == "" {
			session.signInWithTestCreds { (error, output) in
				self._handleUserAccessCallback(error, output: output, context: context)
			}
		} else {
			session.signIn(email: email, password: password) { (error, output) in
				self._handleUserAccessCallback(error, output: output, context: context)
			}
		}
	}
	
	private func _handleUserAccessCallback(error: NSError?, output: UserAccessAPIOutput?, context: UIViewController) {
		if let error = error {
			context.present(error)
		}
		
		guard let output = output else { return }
		if let message = output.message where !output.success {
			context.presentMessage(message)
		}
		if output.success {
			self._coordinationController?.instantiatePlayer { error in
				self._coordinationController?.errorPresentationContext = self._mainPlayerVC
				self.rootNavController.pushViewController(self._mainPlayerVC, animated: true)
			}
		}
	}
}