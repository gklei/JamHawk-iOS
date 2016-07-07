//
//  UserAccessAPIInput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

struct UserAccessCredentials: JSONEncodable {
	let email: String
	let password: String
	
	func toJSON() -> JSON {
		return .Dictionary([
			"email" : .String(email),
			"pass" : .String(password)
			])
	}
}

enum UserAccessAction: JSONEncodable {
	case SignUp, SignIn, SignOut
	
	private var jsonValue: String {
		switch self {
		case .SignUp: return "signup"
		case .SignIn: return "signin"
		case .SignOut: return "signout"
		}
	}
	
	func toJSON() -> JSON {
		return .String(jsonValue)
	}
}