//
//  GenreSelectionOnboardingViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class GenreSelectionOnboardingViewController: UIViewController {
	
	@IBOutlet private var container: UIView!
	
	// MARK: - Properties
	var backClosure: () -> Void = {}
	var continueClosure: () -> Void = {}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		backClosure = {
			self.navigationController?.popViewControllerAnimated(true)
		}
		
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let backSel = #selector(SignInViewController.backItemPressed)
		let continueSel = #selector(SignInViewController.continueItemPressed)
		
		updateLeftBarButtonItem(withTitle: "   Back", action: backSel)
		updateRightBarButtonItem(withTitle: "Continue   ", action: continueSel)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	internal func continueItemPressed() {
		continueClosure()
	}
	
	internal func backItemPressed() {
		backClosure()
	}
}
