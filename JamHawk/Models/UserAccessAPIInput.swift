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
	
	private var textValue: String {
		switch self {
		case .SignUp: return "signup"
		case .SignIn: return "signin"
		case .SignOut: return "signout"
		}
	}
	
	func toJSON() -> JSON {
		return .String(textValue)
	}
}

struct UserAccessAPIInput {
	let credentials: UserAccessCredentials
	let action: UserAccessAction
	let token: String
}

extension UserAccessAPIInput: JSONEncodable {
	func toJSON() -> JSON {
		return .Dictionary([
			"credentials" : credentials.toJSON(),
			"action" : action.toJSON(),
			"token" : .String(token)
			])
	}
}

extension UserAccessAPIInput: APIRequestGeneration {
	func generateRequest() -> NSURLRequest? {
		let request = NSMutableURLRequest(URL: JamHawkAPIURLProvider.user)
		request.HTTPMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		guard let inputData = generateJSONData() else { return nil }
		guard let inputString = NSString(data: inputData, encoding: NSUTF8StringEncoding) else { return nil }
		request.HTTPBody = "clazha_access=\(inputString)".dataUsingEncoding(NSUTF8StringEncoding)
		
		return request
	}
}