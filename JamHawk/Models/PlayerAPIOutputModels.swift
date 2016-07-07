//
//  PlayerAPIOutputModels.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

struct PlayerAPIOutputInstance: JSONDecodable, JamHawkJSONDecodable, JSONEncodable {
	let playerID: String?
	let options: [String : JSON]?
	
	init(json: JSON) throws {
		playerID = try json.string("playerID", alongPath: .MissingKeyBecomesNil)
		options = try json.dictionary("options", alongPath: .MissingKeyBecomesNil)
	}
	
	func toJSON() -> JSON {
		let json: JSONDictionaryType = [
			"playerID" : playerID?.toJSON() ?? .Null,
//			"options" : options?.toJSON() ?? .Null -------------> TODO: figure out what to do with "options"
		]
		return JSON.withNullValuesRemoved(json)
	}
}

struct PlayerAPIOutputMedia: JSONDecodable, JamHawkJSONDecodable, JSONEncodable {
	let poster: String?
	let mp3: String?
	let m4a: String?
	let m4v: String?
	
	init(json: JSON) throws {
		poster = try json.string("poster", alongPath: .MissingKeyBecomesNil)
		mp3 = try json.string("mp3", alongPath: .MissingKeyBecomesNil)
		m4a = try json.string("m4a", alongPath: .MissingKeyBecomesNil)
		m4v = try json.string("m4v", alongPath: .MissingKeyBecomesNil)
	}
	
	func toJSON() -> JSON {
		let json: JSONDictionaryType = [
			"poster" : poster?.toJSON() ?? .Null,
			"mp3" : mp3?.toJSON() ?? .Null,
			"m4a" : m4a?.toJSON() ?? .Null,
			"m4v" : m4v?.toJSON() ?? .Null
		]
		return JSON.withNullValuesRemoved(json)
	}
}

struct PlayerAPIOutputArtist: JSONDecodable, JamHawkJSONDecodable, JSONEncodable {
	let imageURL: String?
	let name: String?
	let text: String?
	
	init(json: JSON) throws {
		imageURL = try json.string("imageURL", alongPath: .MissingKeyBecomesNil)
		name = try json.string("name", alongPath: .MissingKeyBecomesNil)
		text = try json.string("text", alongPath: .MissingKeyBecomesNil)
	}
	
	func toJSON() -> JSON {
		let json: JSONDictionaryType = [
			"imageURL" : imageURL?.toJSON() ?? .Null,
			"name" : name?.toJSON() ?? .Null,
			"text" : text?.toJSON() ?? .Null
		]
		return JSON.withNullValuesRemoved(json)
	}
}

struct PlayerAPIOutputMetadata: JSONDecodable, JamHawkJSONDecodable, JSONEncodable {
	let mid: PlayerAPIMediaID?
	let artist: String?
	let album: String?
	let title: String?
	let detailURL: String?
	let imageURL: String?
	let rating: PlayerAPITrackRating?
	let duration: Int?
	let links: [String]?
	
	init(json: JSON) throws {
		mid = try json.int("mid", alongPath: .MissingKeyBecomesNil)
		artist = try json.string("artist", alongPath: .MissingKeyBecomesNil)
		album = try json.string("album", alongPath: .MissingKeyBecomesNil)
		title = try json.string("title", alongPath: .MissingKeyBecomesNil)
		detailURL = try json.string("detailURL", alongPath: .MissingKeyBecomesNil)
		imageURL = try json.string("imageURL", alongPath: .MissingKeyBecomesNil)
		rating = try json.decode("rating", alongPath: .MissingKeyBecomesNil, type: PlayerAPITrackRating.self)
		duration = try json.int("duration", alongPath: .MissingKeyBecomesNil)
		links = try json.array("links", alongPath: .MissingKeyBecomesNil)?.map(String.init)
	}
	
	func toJSON() -> JSON {
		let json: JSONDictionaryType = [
			"mid" : mid?.toJSON() ?? .Null,
			"artist" : artist?.toJSON() ?? .Null,
			"album" : album?.toJSON() ?? .Null,
			"title" : title?.toJSON() ?? .Null,
			"detailURL" : detailURL?.toJSON() ?? .Null,
			"imageURL" : imageURL?.toJSON() ?? .Null,
			"rating" : rating?.toJSON() ?? .Null,
			"duration" : duration?.toJSON() ?? .Null,
			"links" : links?.toJSON() ?? .Null
		]
		return JSON.withNullValuesRemoved(json)
	}
}

struct PlayerAPIOutputMessage: JSONDecodable, JamHawkJSONDecodable {
	let message: String?
	let type: String?
	
	init(json: JSON) throws {
		message = try json.string("message", alongPath: .MissingKeyBecomesNil)
		type = try json.string("type", alongPath: .MissingKeyBecomesNil)
	}
}

struct PlayerAPIOutputCommand: JSONDecodable, JamHawkJSONDecodable {
	let name: PlayerAPICommandName
	let parameters: [String]
	
	init(json: JSON) throws {
		name = try json.decode("name", type: PlayerAPICommandName.self)
		parameters = try json.arrayOf("parameters", type: String.self)
	}
}

struct PlayerAPIOutputFilters: JSONDecodable, JamHawkJSONDecodable {
	let available: [PlayerAPIFilter]?
	let selected: [PlayerAPIFilterID]?
	
	init(json: JSON) throws {
		available = try json.arrayOf("available", alongPath: .MissingKeyBecomesNil, type: PlayerAPIFilter.self)
		selected = try json.arrayOf("selected",alongPath: .MissingKeyBecomesNil, type: PlayerAPIFilterID.self)
	}
}
