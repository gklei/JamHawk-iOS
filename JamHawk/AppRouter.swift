//
//  AppRouter.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class AppRouter: NSObject {
	let window: UIWindow
	let session: JamHawkSession
	
	let rootNavController = JamHawkNavigationController()
	private let _navigationAnimator = OnboardingNavigationAnimator()
	
	private var _coordinationController: SystemCoordinationController?
	private let _mainPlayerVC = MainPlayerViewController.create()
	private let _welcomeVC = WelcomeViewController.instantiate(fromStoryboard: "SignIn")
	private let _signInVC = SignInViewController.instantiate(fromStoryboard: "SignIn")
	private let _signUpVC = SignUpViewController.instantiate(fromStoryboard: "SignIn")
	private let _welcomeBackgroundVC = WelcomeBackgroundViewController()
	
	// MARK: - Onboarding View Controllers
	private let _genreSelectionVC = GenreSelectionOnboardingViewController.instantiate(fromStoryboard: "SignIn")
	private let _popularitySelectionVC = PopularitySelectionOnboardingViewController.instantiate(fromStoryboard: "SignIn")
	private let _onboardingCompletionVC = OnboardingCompletionViewController.instantiate(fromStoryboard: "SignIn")
	
	init(window: UIWindow, session: JamHawkSession) {
		self.window = window
		self.session = session
		super.init()
		
		_setupNavigationClosures()
		_setupPlayerAndSystems()
		_setupWindow()
	}
	
	private func _setupNavigationClosures() {
		_welcomeVC.signUpClosure = _showSignInUI
		_welcomeVC.getStartedClosure = _showGenreSelectionUI
		_genreSelectionVC.continueClosure = _showPopularitySelectionUI
		_popularitySelectionVC.continueClosure = _showOnboardingCompletionUI
		_onboardingCompletionVC.signUpButtonClosure = _showSignUpUI
		_signInVC.continueClosure = _trySignIn
	}
	
	private func _setupPlayerAndSystems() {
		_coordinationController = SystemCoordinationController(apiService: session)
		_mainPlayerVC.setupSystems(withCoordinationController: _coordinationController!)
	}
	
	private func _setupWindow() {
		window.rootViewController = _welcomeBackgroundVC
		window.makeKeyAndVisible()
		
		rootNavController.delegate = self
		rootNavController.viewControllers = [_welcomeVC]
		rootNavController.modalPresentationStyle = .OverCurrentContext
		
		_welcomeBackgroundVC.presentViewController(rootNavController, animated: false, completion: nil)
	}
}

// MARK: - Signing In & Up
extension AppRouter {
	
	private func _showSignInUI() {
		rootNavController.pushViewController(_signInVC, animated: true)
	}
	
	private func _showSignUpUI() {
		rootNavController.pushViewController(_signUpVC, animated: true)
	}
	
	private func _showGenreSelectionUI() {
		rootNavController.pushViewController(_genreSelectionVC, animated: true)
	}
	
	private func _showPopularitySelectionUI() {
		rootNavController.pushViewController(_popularitySelectionVC, animated: true)
	}
	
	private func _showOnboardingCompletionUI() {
		rootNavController.pushViewController(_onboardingCompletionVC, animated: true)
	}
	
	private func _trySignIn() {
		let email = _signInVC.emailText
		let password = _signInVC.passwordText
		
		_signIn(email, password: password, context: _signInVC)
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
			_coordinationController?.instantiatePlayer(_playerInstantiationCallback)
		}
	}
	
	private func _playerInstantiationCallback(error: NSError?) {
		_coordinationController?.errorPresentationContext = self._mainPlayerVC
		rootNavController.pushViewController(_mainPlayerVC, animated: true)
	}
}

extension AppRouter: UINavigationControllerDelegate {
	
	@objc func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		_navigationAnimator.reverse = operation == .Pop
		
		switch toVC {
		case _signInVC, _signUpVC: return nil
		case _onboardingCompletionVC: return fromVC == _signUpVC ? nil : _navigationAnimator
		case _welcomeVC: return fromVC == _signInVC ? nil : _navigationAnimator
		case _mainPlayerVC: return nil
		default: return _navigationAnimator
		}
	}
	
	func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
		if animated {
			var alpha: CGFloat?
			var barItemColor = UIColor.jmhTurquoiseColor()
			switch viewController {
			case _genreSelectionVC:
				barItemColor = .whiteColor()
				alpha = 0.3
			case _popularitySelectionVC:
				barItemColor = .whiteColor()
			case _signInVC, _signUpVC:
				barItemColor = .jmhTurquoiseColor()
			case _welcomeVC:
				alpha = 0.5
			case _onboardingCompletionVC:
				barItemColor = .whiteColor()
			default: break
			}
			
			if let a = alpha {
				UIView.animateWithDuration(0.3, animations: { 
					self._welcomeBackgroundVC.imageView.alpha = a
				})
			}
			updateNavigationBarItemColor(barItemColor)
		}
	}
}