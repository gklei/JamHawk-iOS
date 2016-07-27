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
	
	private let _tempInitialVC = TemporaryInitialViewController.instantiate(fromStoryboard: "SignIn")
	private let _mainPlayerVC = MainPlayerViewController.create()
	
	init(window: UIWindow, session: JamHawkSession) {
		self.window = window
		self.session = session
		
		_coordinationController = SystemCoordinationController(apiService: session)
		_mainPlayerVC.setup(withCoordinationController: _coordinationController!)
		
		_setupWindow(withRootVC: _tempInitialVC)
		_tempInitialVC.update(.SigningIn)
		
		session.signInWithTestCreds { (error, output) in
			self._tempInitialVC.update(.InstantiatingPlayer)
			self._handleUserAccessCallback(error, output: output, context: self._tempInitialVC)
		}
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
			self._coordinationController?.instantiatePlayer({ (error, output) in
				self._handlePlayerInstantiationCallback(error, output: output, context: context)
			})
		}
	}
}

// MARK: - Main Player
extension AppRouter {
	private func _handlePlayerInstantiationCallback(error: NSError?, output: PlayerAPIOutput?, context: UIViewController) {
		if let error = error {
			context.present(error)
		} else {
			_coordinationController?.errorPresentationContext = _mainPlayerVC
			rootNavController.pushViewController(_mainPlayerVC, animated: true)
		}
	}
}