//
//  TemporaryInitialViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/11/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum TemporaryInitialState: String {
	case SigningIn = "Signing in with test account..."
	case InstantiatingPlayer = "Instantiating player..."
}

class TemporaryInitialViewController: UIViewController {
	// MARK: - Outlets
	@IBOutlet private var _mainLabel: UILabel!
	
	// MARK: - Public
	func update(state: TemporaryInitialState) {
		_mainLabel.text = state.rawValue
	}
}
