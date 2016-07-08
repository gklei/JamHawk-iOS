//
//  UIStoryboard+Extensions.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum StoryboardType: String {
	case LaunchScreen, SignIn, SignUp, Onboarding, Player
}

extension UIStoryboard {
	convenience init(type: StoryboardType) {
		self.init(name: type.rawValue, bundle: nil)
	}
}