//
//  PlayerAPITypealiases.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

typealias PlayerAPIMediaID = Int
typealias PlayerAPIFilterID = String
typealias PlayerAPIFilterSelection = Dictionary<PlayerAPIFilterID, PlayerAPIFilterID>
typealias PlayerAPIMediaRatings = Dictionary<PlayerAPIMediaID, PlayerAPITrackRating>

enum PlayerAPITrackRating: Int, JSONEncodable, JSONDecodable {
	case Negative = -1, Neutral = 0, Positive = 1
	
	init(json: JSON) throws {
		let raw = try Int(json: json)
		if let _ = PlayerAPITrackRating(rawValue: raw) {
			self.init(rawValue: raw)!
		} else {
			throw JSON.Error.ValueNotConvertible(value: json, to: PlayerAPITrackRating.self)
		}
	}
	
	func toJSON() -> JSON {
		return .Int(rawValue)
	}
}

enum PlayerAPICommandName: String, JSONEncodable, JSONDecodable {
	case Wait = "wait", Deactivate = "deactivate", Request = "request", Redirect = "redirect"
	
	init(json: JSON) throws {
		let name = try String(json: json)
		if let _ = PlayerAPICommandName(rawValue: name) {
			self.init(rawValue: name)!
		} else {
			throw JSON.Error.ValueNotConvertible(value: json, to: PlayerAPICommandName.self)
		}
	}
	
	func toJSON() -> JSON {
		return .String(rawValue)
	}
}

struct PlayerAPIFilter: JSONEncodable, JSONDecodable {
	let category: String
	let label: String
	let filterNames: [String]
	let filterIDs: [PlayerAPIFilterID]
	
	init(json: JSON) throws {
		category = try json.string("category")
		label = try json.string("label")
		filterNames = try json.arrayOf("filterNames", type: String.self)
		filterIDs = try json.arrayOf("filterIDs", type: PlayerAPIFilterID.self)
	}
	
	func toJSON() -> JSON {
		return .Dictionary([
			"category" : .String(category),
			"label" : .String(label),
			"filterNames" : filterNames.toJSON(),
			"filterIDs" : filterIDs.toJSON()
			])
	}
}