//
//  SettingsRouter.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class SettingsRouter: NSObject {
	
	// MARK: - Properties
	let rootNavigationController: UINavigationController
	
	private let _profileViewController = ProfileViewController.instantiate(fromStoryboard: "Profile")
	private let _editProfileViewController = EditProfileViewController.instantiate(fromStoryboard: "Profile")
	private let _ProfileSettingsViewController = ProfileSettingsViewController.instantiate(fromStoryboard: "Profile")
	
	init(rootNavigationController: UINavigationController) {
		self.rootNavigationController = rootNavigationController
		self.rootNavigationController.viewControllers = [_profileViewController]
		
		super.init()
		
		_profileViewController.delegate = self
		_editProfileViewController.delegate = self
		_ProfileSettingsViewController.delegate = self
	}
}

extension SettingsRouter: ProfileViewControllerDelegate {
	func profileViewController(controller: ProfileViewController, optionSelected option: ProfileOptionType) {
		switch option {
		case .EditProfile:
			rootNavigationController.pushViewController(_editProfileViewController, animated: true)
		case .Settings:
			rootNavigationController.pushViewController(_ProfileSettingsViewController, animated: true)
		}
	}
}

extension SettingsRouter: EditProfileViewControllerDelegate {
	func editProfileViewController(controller: EditProfileViewController, optionSelected option: EditProfileOptionType) {
		switch option {
		case .Email: print("Edit email!")
		case .Password: print("Edit password!")
		}
	}
}

extension SettingsRouter: ProfileSettingsViewControllerDelegate {
	func profileSettingsViewController(controller: ProfileSettingsViewController, optionSelected option: ProfileSettingsOptionType) {
		switch option {
		case .Share: print("Share!")
		case .TermsAndConditions: print("Show terms and conditions!")
		}
	}
}