//
//  PlayerAPIOutputModels.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

struct PlayerAPIOutputInstance: JSONDecodable, JSONEncodable {
	let playerID: String?
	let options: [String : JSON]?
	
	init(json: JSON) throws {
		playerID = try json.string("playerID", alongPath: .MissingKeyBecomesNil)
		options = try json.dictionary("options", alongPath: .MissingKeyBecomesNil)
	}
	
	func toJSON() -> JSON {
		let json: [Swift.String : JSON] = [
			"playerID" : playerID?.toJSON() ?? JSON.Null,
//			"options" : options?.toJSON() ?? JSON.Null -------------> TODO: figure out options is
		]
		return JSON.withNullValuesRemoved(json)
	}
}

struct PlayerAPIOutputMedia: JSONDecodable, JSONEncodable {
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
		let json: [Swift.String : JSON] = [
			"poster" : poster?.toJSON() ?? JSON.Null,
			"mp3" : mp3?.toJSON() ?? JSON.Null,
			"m4a" : m4a?.toJSON() ?? JSON.Null,
			"m4v" : m4v?.toJSON() ?? JSON.Null
		]
		return JSON.withNullValuesRemoved(json)
	}
}

struct PlayerAPIOutputArtist: JSONDecodable, JSONEncodable {
	let imageURL: String?
	let name: String?
	let text: String?
	
	init(json: JSON) throws {
		imageURL = try json.string("imageURL", alongPath: .MissingKeyBecomesNil)
		name = try json.string("name", alongPath: .MissingKeyBecomesNil)
		text = try json.string("text", alongPath: .MissingKeyBecomesNil)
	}
	
	func toJSON() -> JSON {
		let json: [Swift.String : JSON] = [
			"imageURL" : imageURL?.toJSON() ?? JSON.Null,
			"name" : name?.toJSON() ?? JSON.Null,
			"text" : text?.toJSON() ?? JSON.Null
		]
		return JSON.withNullValuesRemoved(json)
	}
}

struct PlayerAPIOutputMetadata: JSONDecodable, JSONEncodable {
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
		links = try json.arrayOf("links", alongPath: .MissingKeyBecomesNil, type: String.self)
	}
	
	func toJSON() -> JSON {
		let json: [String : JSON] = [
			"mid" : mid?.toJSON() ?? JSON.Null,
			"artist" : artist?.toJSON() ?? JSON.Null,
			"album" : album?.toJSON() ?? JSON.Null,
			"title" : title?.toJSON() ?? JSON.Null,
			"detailURL" : detailURL?.toJSON() ?? JSON.Null,
			"imageURL" : imageURL?.toJSON() ?? JSON.Null,
			"rating" : rating?.toJSON() ?? JSON.Null,
			"duration" : duration?.toJSON() ?? JSON.Null,
			"links" : links?.toJSON() ?? JSON.Null
		]
		return JSON.withNullValuesRemoved(json)
	}
}

struct PlayerAPIOutputMessage: JSONDecodable, JSONEncodable {
	let message: String?
	let type: String?
	
	init(json: JSON) throws {
		message = try json.string("message", alongPath: .MissingKeyBecomesNil)
		type = try json.string("type", alongPath: .MissingKeyBecomesNil)
	}
	
	func toJSON() -> JSON {
		let json: [Swift.String : JSON] = [
			"message" : message?.toJSON() ?? JSON.Null,
			"type" : type?.toJSON() ?? JSON.Null
		]
		return JSON.withNullValuesRemoved(json)
	}
}

struct PlayerAPIOutputCommand: JSONDecodable, JSONEncodable {
	let name: PlayerAPICommandName
	let parameters: [String]?
	
	init(json: JSON) throws {
		name = try json.decode("name", type: PlayerAPICommandName.self)
		parameters = try json.arrayOf("parameters", type: String.self)
	}
	
	func toJSON() -> JSON {
		let json: [Swift.String : JSON] = [
			"name" : name.toJSON(),
			"parameters" : parameters?.toJSON() ?? JSON.Null
		]
		return JSON.withNullValuesRemoved(json)
	}
}

struct PlayerAPIOutputFilters: JSONDecodable, JSONEncodable {
	let available: [PlayerAPIFilter]?
	let selected: [PlayerAPIFilterID]?
	
	init(json: JSON) throws {
		available = try json.arrayOf("available", alongPath: .MissingKeyBecomesNil, type: PlayerAPIFilter.self)
		selected = try json.arrayOf("selected",alongPath: .MissingKeyBecomesNil, type: PlayerAPIFilterID.self)
	}
	
	func toJSON() -> JSON {
		let json: [Swift.String : JSON] = [
			"available" : available?.toJSON() ?? JSON.Null,
			"selected" : selected?.toJSON() ?? JSON.Null
		]
		return JSON.withNullValuesRemoved(json)
	}
}
