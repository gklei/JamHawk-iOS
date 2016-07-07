//
//  UserAccessAPIInput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

struct UserInputCredentials: JSONEncodable {
	let email: String
	let password: String
	
	func toJSON() -> JSON {
		return .Dictionary([
			"email" : .String(email),
			"pass" : .String(password)
			])
	}
}

enum UserInputAction: JSONEncodable {
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

struct UserAccessAPIInput: JSONEncodable {
	let credentials: UserInputCredentials
	let action: UserInputAction
	let token: String
	
	func toJSON() -> JSON {
		return .Dictionary([
			"credentials" : credentials.toJSON(),
			"action" : action.toJSON(),
			"token" : .String(token)
			])
	}
	
	private var data: NSData? {
		var data: NSData?
		do {
			data = try toJSON().serialize()
		} catch let error {
			print(error)
		}
		return data
	}
	
	func apiRequest() -> NSURLRequest? {
		
		let request = NSMutableURLRequest(URL: JamHawkAPIURLProvider.user)
		request.HTTPMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		guard let inputData = data else { return nil }
		guard let inputString = NSString(data: inputData, encoding: NSUTF8StringEncoding) else { fatalError() }
		request.HTTPBody = "clazha_access=\(inputString)".dataUsingEncoding(NSUTF8StringEncoding)
		
		return request
	}
}