//
//  ViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import IncipiaKit

class SignInViewController: UIViewController
{
	@IBOutlet private var _emailTextField: BottomBorderTextField!
	@IBOutlet private var _passwordTextField: BottomBorderTextField!

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	@IBAction func _viewTapped(recognizer: UITapGestureRecognizer) {
		view.endEditing(true)
	}
}

