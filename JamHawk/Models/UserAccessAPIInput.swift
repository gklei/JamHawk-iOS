//
//  UserAccessAPIInput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

struct UserAccessAPIInput {
	let credentials: UserAccessCredentials
	let action: UserAccessAction
	let token: String
}

extension UserAccessAPIInput: JSONEncodable {
	func toJSON() -> JSON {
		let json = JSON.Dictionary([
			"credentials" : credentials.toJSON(),
			"action" : action.toJSON(),
			"token" : .String(token)
			])
		return json
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