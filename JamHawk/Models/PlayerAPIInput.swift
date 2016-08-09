//
//  PlayerAPIInput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

struct PlayerAPIInput {
	let instance: PlayerAPIInputInstance?
	let status: PlayerAPIInputStatus
	let updates: PlayerAPIInputUpdates?
	let events: [PlayerAPIInputEvent]?
}

private let PlayerAPIInputEventLimit = 16

extension PlayerAPIInput: JSONEncodable {
	func toJSON() -> JSON {
		let inputEvents = Array(events?.prefix(PlayerAPIInputEventLimit) ?? [])
		let dictionary: [String : JSON] = [
			"instance" : instance?.toJSON() ?? JSON.Null,
			"status" : status.toJSON(),
			"updates" : updates?.toJSON() ?? JSON.Null,
			"events" : inputEvents.toJSON() ?? JSON.Null
		]
		return JSON.withoutNullValues(dictionary)
	}
}

extension PlayerAPIInput: APIRequestGeneration {
	
	func generateRequest() -> NSURLRequest? {
		let request = NSMutableURLRequest(URL: JamHawkAPIURLProvider.player)
		request.HTTPMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		guard let inputData = generateJSONData() else { return nil }
		guard let inputString = NSString(data: inputData, encoding: NSUTF8StringEncoding) else { return nil }
		request.HTTPBody = "clazha_player=\(inputString)".dataUsingEncoding(NSUTF8StringEncoding)
		
		return request
	}
}