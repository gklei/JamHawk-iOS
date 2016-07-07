//
//  UserAccessAPIOutput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

struct UserAccessAPIOutput {
	let success: Bool
	let message: String?
	
	init?(jsonData: NSData?) {
		guard let data = jsonData else { return nil }
		do {
			let json = try JSON(data: data)
			try self.init(json: json)
		} catch {
			return nil
		}
	}
}

extension UserAccessAPIOutput: JSONDecodable {
	init(json: JSON) throws {
		success = try json.bool("success")
		message = try json.string("message", alongPath: JSON.SubscriptingOptions.MissingKeyBecomesNil)
	}
}
