//
//  PlayerAPIInput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

enum PlayerAPIInputEventName: String, JSONEncodable {
	case Play = "play"
	case Pause = "pause"
	case Resume = "resume"
	case End = "end"
	case Skip = "skip"
	case PreloadedSkip = "preloaded-skip"
	case Error = "error"
	case Warning = "warning"
	
	func toJSON() -> JSON {
		return .String(rawValue)
	}
}

struct PlayerAPIInputEvent: JSONEncodable {
	let name: PlayerAPIInputEventName
	let timestamp: Int
	let mid: PlayerAPIMediaID?
	let description: String?
	
	func toJSON() -> JSON {
		let json: [String : JSON] = [
			"name" : name.toJSON(),
			"timestamp" : timestamp.toJSON(),
			"mid" : mid?.toJSON() ?? JSON.Null,
			"description" : description?.toJSON() ?? JSON.Null
		]
		return JSON.withoutNullValues(json)
	}
}

struct PlayerAPIInputInstance: JSONEncodable {
	let token: String?
	let needPlayerID: Bool
	let needOptions: Bool
	let isMobile: Bool?
	let preloadSync: Bool?
	
	func toJSON() -> JSON {
		let dictionary: [String : JSON] = [
			"token" : token?.toJSON() ?? JSON.Null,
			"needPlayerID" : needPlayerID.toJSON(),
			"needOptions" : needOptions.toJSON(),
			"isMobile" : isMobile?.toJSON() ?? JSON.Null,
			"preloadSync" : preloadSync?.toJSON() ?? JSON.Null
		]
		return JSON.withoutNullValues(dictionary)
	}
}

struct PlayerAPIInputFilterSelection: JSONEncodable {
	let selection: PlayerAPIFilterSelection
	
	func toJSON() -> JSON {
		var json: [String : JSON] = [:]
		for (category, filterIDs) in selection {
			json[category] = filterIDs.toJSON()
		}
		
		return ["any" : JSON.withoutNullValues(json)]
	}
}
