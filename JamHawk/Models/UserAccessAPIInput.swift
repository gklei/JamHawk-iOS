//
//  UserAccessAPIInput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

enum UserInputAction {
	case SignUp, SignIn, SignOut
	
	var text: String {
		switch self {
		case .SignUp: return "signup"
		case .SignIn: return "signin"
		case .SignOut: return "signout"
		}
	}
}

struct UserAccessAPIInput {
	let email: String
	let password: String
	let action: UserInputAction
	let token: String
}

extension UserAccessAPIInput: JSONEncodable {
	func toJSON() -> JSON {
		return .Dictionary([
			"action" : .String(action.text),
			"credentials" : .Dictionary(["email" : .String(email), "pass" : .String(password)]),
			"token" : .String(token)
			])
	}
}