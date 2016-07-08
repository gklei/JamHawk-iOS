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
		return JSON.withNullValuesRemoved(json)
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
		return JSON.withNullValuesRemoved(dictionary)
	}
}

struct PlayerAPIInputStatus: JSONEncodable {
	let playerID: String
	let requestID: Int
	let needInstance: Bool
	let needMedia: Bool
	let needNext: Bool
	let needFilters: Bool
	
	static func instanceRequestStatus() -> PlayerAPIInputStatus {
		return PlayerAPIInputStatus(playerID: "", requestID: 0, needInstance: true, needMedia: true, needNext: true, needFilters: true)
	}
	
	func toJSON() -> JSON {
		return .Dictionary([
			"playerID" : playerID.toJSON(),
			"requestID" : requestID.toJSON(),
			"needInstance" : needInstance.toJSON(),
			"needMedia" : needMedia.toJSON(),
			"needNext" : needNext.toJSON(),
			"needFilters" : needFilters.toJSON()
			])
	}
}

struct PlayerAPIInputUpdates: JSONEncodable {
	let abandonedRequests: [Int]?
	let canPlay: Bool?
	let filter: PlayerAPIFilterSelection?
	let select: Int?
	let ratings: PlayerAPIMediaRatings?
	
	func toJSON() -> JSON {
		let json: [String : JSON] = [
			"abandonedRequests" : abandonedRequests?.toJSON() ?? JSON.Null,
			"canPlay" : canPlay?.toJSON() ?? JSON.Null,
			"filter" : filter?.toJSON() ?? JSON.Null,
			"select" : select?.toJSON() ?? JSON.Null,
			"ratings" : ratings?.toJSON() ?? JSON.Null
		]
		return JSON.withNullValuesRemoved(json)
	}
}
