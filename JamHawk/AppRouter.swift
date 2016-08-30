//
//  AppRouter.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import SwiftSpinner

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
		
		ProfileViewController.addObserver(self, selector: #selector(AppRouter.signOut), notification: .signOut)
		_signInIfCredentialsPresent()
	}
	
	private func _signInIfCredentialsPresent() {
		if let credentials = JamhawkStorage.lastUsedCredentials {
			SwiftSpinner.show("Signing In...")
			session.signIn(email: credentials.email, password: credentials.password) { (error, output) in
				SwiftSpinner.hide()
				self._handleUserAccessCallback(error, output: output, credentials: credentials, context: self._welcomeVC)
			}
		}
	}
	
	func signOut() {
		guard let creds = JamhawkStorage.lastUsedCredentials else { return }
		
		_coordinationController?.killPlayer()
		rootNavController.navigationBarHidden = false
		rootNavController.popToRootViewControllerAnimated(true)
		
		session.signOut(email: creds.email, password: creds.password) { (error, output) in
			if let error = error {
				self.rootNavController.present(error)
			}
			
			guard let output = output else { return }
			if let message = output.message where !output.success {
				self.rootNavController.presentMessage(message)
			}
			JamhawkStorage.lastUsedCredentials = nil
		}
	}
	
	private func _setupNavigationClosures() {
		_welcomeVC.signUpClosure = _showSignInUI
		_welcomeVC.getStartedClosure = _showGenreSelectionUI
		_genreSelectionVC.continueClosure = _showPopularitySelectionUI
		_popularitySelectionVC.continueClosure = _showOnboardingCompletionUI
		_onboardingCompletionVC.signUpButtonClosure = _showSignUpUI
		_signInVC.continueClosure = _trySignIn
		_signUpVC.continueClosure = _trySignUp
		
		_signInVC.forgotPasswordClosure = _resetPassword
	}
	
	private func _setupPlayerAndSystems() {
		_coordinationController = SystemCoordinationController(apiService: session)
		
		_mainPlayerVC.session = session
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
		SwiftSpinner.show("Signing In...")
		
		let creds = (email: _signInVC.emailText, password: _signInVC.passwordText)
		session.signIn(email: creds.email, password: creds.password) { (error, output) in
			SwiftSpinner.hide()
			self._handleUserAccessCallback(error, output: output, credentials: creds, context: self._signInVC)
		}
	}
	
	private func _trySignUp() {
		guard _signUpVC.passwordsMatch() else {
			_signUpVC.presentMessage("The passwords do not match.")
			return
		}
		
		SwiftSpinner.show("Signing Up...")
		
		let creds = (email: _signUpVC.emailText, password: _signUpVC.passwordText)
		session.signUp(email: creds.email, password: creds.password) { (error, output) in
			SwiftSpinner.hide()
			self._handleUserAccessCallback(error, output: output, credentials: creds, context: self._signUpVC)
		}
	}
	
	private func _resetPassword() {
		print("Reset password!")
	}
	
	private func _handleUserAccessCallback(error: NSError?,
	                                       output: UserAccessAPIOutput?,
	                                       credentials: (email: String, password: String),
	                                       context: UIViewController) {
		if let error = error {
			context.present(error)
		}
		
		guard let output = output else { return }
		if let message = output.message where !output.success {
			context.presentMessage(message)
		}
		if output.success {
			JamhawkStorage.lastUsedCredentials = credentials
			let selection = _generateFilterSelectionFromOnboarding()
			let completion = _playerInstantiationCallback
			
			SwiftSpinner.show("Setting up Player...")
			_coordinationController?.instantiatePlayer(filterSelection: selection, completion: completion)
		}
	}
	
	private func _generateFilterSelectionFromOnboarding() -> PlayerAPIInputFilterSelection? {
		var selectedTypes = _genreSelectionVC.selectedFilterTypes
		selectedTypes.appendContentsOf(_popularitySelectionVC.selectedFilterTypes)
		
		var selection: PlayerAPIFilterSelection = [:]
		selectedTypes.forEach {
			if selection.keys.contains($0.category) {
				selection[$0.category]?.append($0.filterID)
			} else {
				selection[$0.category] = [$0.filterID]
			}
		}
		return PlayerAPIInputFilterSelection(selection: selection)
	}
	
	private func _playerInstantiationCallback(error: NSError?) {
		SwiftSpinner.hide()
		_coordinationController?.errorPresentationContext = self._mainPlayerVC
		
		let showCoachingTips = !JamhawkStorage.userHasSeenCoachingTips
		_mainPlayerVC.showCoachingTips = showCoachingTips
		
		if !showCoachingTips {
			rootNavController.setNavigationBarHidden(true, animated: true)
		} else {
			_mainPlayerVC.title = "30 sec setup"
		}
		
		rootNavController.pushViewController(_mainPlayerVC, animated: true)
	}
}

extension AppRouter: UINavigationControllerDelegate {
	
	@objc func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		_navigationAnimator.reverse = operation == .Pop
		
		switch toVC {
		case _signInVC, _signUpVC: return nil
		case _onboardingCompletionVC: return fromVC == _signUpVC ? nil : _navigationAnimator
		case _welcomeVC: return fromVC == _signInVC || fromVC == _mainPlayerVC ? nil : _navigationAnimator
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