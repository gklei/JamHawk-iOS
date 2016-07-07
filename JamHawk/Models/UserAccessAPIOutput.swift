//
//  UserAccessAPIOutput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

struct UserAccessAPIOutput: JamHawkJSONDecodable {
	let success: Bool
	let message: String?
}

extension UserAccessAPIOutput: JSONDecodable {
	init(json: JSON) throws {
		success = try json.bool("success")
		message = try json.string("message", alongPath: JSON.SubscriptingOptions.MissingKeyBecomesNil)
	}
}
