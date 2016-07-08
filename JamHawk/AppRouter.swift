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
	
	private let _signInVC = SignInViewController.instantiate(.SignIn)
	private let _mainPlayerVC = MainPlayerViewController.instantiate(.Player)
	
	init(window: UIWindow, session: JamHawkSession) {
		self.window = window
		self.session = session
		
		_signInVC.signUpButtonPressed = _signUp
		_signInVC.signInButtonPressed = _signIn
		
		_setupWindow(withRootVC: _signInVC)
	}
	
	private func _setupWindow(withRootVC rootVC: UIViewController) {
		rootNavController.viewControllers = [rootVC]
		window.rootViewController = rootNavController
		window.makeKeyAndVisible()
	}
}

// MARK: - Signing In & Up
extension AppRouter {
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
			self.session.instantiatePlayer({ (error, playerOutput) in
				self._handlePlayerInstantiationCallback(error, output: playerOutput, context: context)
			})
		}
	}
}

// MARK: - Main Player
extension AppRouter {
	private func _handlePlayerInstantiationCallback(error: NSError?, output: PlayerAPIOutput?, context: UIViewController) {
		if let error = error {
			context.present(error)
		}
		
		guard let output = output else { return }
		_showMainPlayer()
		print(output)
		
	}
	
	private func _showMainPlayer() {
		dispatch_async(dispatch_get_main_queue()) {
			self.rootNavController.pushViewController(self._mainPlayerVC, animated: true)
		}
	}
}