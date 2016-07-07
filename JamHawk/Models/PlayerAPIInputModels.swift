//
//  PlayerAPIInput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

enum PlayerAPIInputEventName: JSONEncodable {
	case Play, Pause, Resume, End, Skip, PreloadedSkip, Error, Warning
	
	private var jsonValue: String {
		switch self {
		case .Play: return "play"
		case .Pause: return "pause"
		case .Resume: return "resume"
		case .End: return "end"
		case .Skip: return "skip"
		case .PreloadedSkip: return "preloaded-skip"
		case .Error: return "error"
		case .Warning: return "warning"
		}
	}
	
	func toJSON() -> JSON {
		return .String(jsonValue)
	}
}

struct PlayerAPIInputEvent: JSONEncodable {
	let name: PlayerAPIInputEventName
	let timestamp: Int
	let mid: PlayerAPIMediaID?
	let description: String?
	
	func toJSON() -> JSON {
		let dictionary: [String : JSON] = [
			"name" : name.toJSON(),
			"timestamp" : .Int(timestamp),
			"mid" : mid != nil ? .Int(mid!) : .Null,
			"description" : description != nil ? .String(description!) : .Null
		]
		
		return JSON.withNullValuesRemoved(dictionary)
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
			"token" : token != nil ? .String(token!) : .Null,
			"needPlayerID" : .Bool(needPlayerID),
			"needOptions" : .Bool(needOptions),
			"isMobile" : isMobile != nil ? .Bool(isMobile!) : .Null,
			"preloadSync" : preloadSync != nil ? .Bool(preloadSync!) : .Null
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
		return PlayerAPIInputStatus(playerID: "", requestID: 0, needInstance: true, needMedia: true, needNext: false, needFilters: true)
	}
	
	func toJSON() -> JSON {
		return .Dictionary([
			"playerID" : .String(playerID),
			"requestID" : .Int(requestID),
			"needInstance" : .Bool(needInstance),
			"needMedia" : .Bool(needMedia),
			"needNext" : .Bool(needNext),
			"needFilters" : .Bool(needFilters)
			])
	}
}

struct PlayerAPIInputUpdates {
	let abandonedRequests: [Int]
	let canPlay: Bool
	let filter: PlayerAPIFilterSelection
	let select: Int
}
