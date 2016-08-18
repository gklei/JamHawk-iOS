//
//  PlayerAPIOutput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

struct PlayerAPIOutput: JamHawkJSONDecodable {
	let instance: PlayerAPIOutputInstance?
	let url: String?
	let filters: PlayerAPIOutputFilters?
	let media: PlayerAPIOutputMedia?
	let artist: PlayerAPIOutputArtist?
	let track: PlayerAPIOutputMetadata?
	let next: [PlayerAPIOutputMetadata]?
	let messages: [PlayerAPIOutputMessage]?
	let commands: [PlayerAPIOutputCommand]?
	let denied: Bool?
}

extension PlayerAPIOutput: JSONDecodable {
	init(json: JSON) throws {
//		print("PLAYER OUTPUT: \(json)")
		
		instance = try json.decode("instance", alongPath: .MissingKeyBecomesNil, type: PlayerAPIOutputInstance.self)
		url = try json.string("url", alongPath: .MissingKeyBecomesNil)
		filters = try json.decode("filters", alongPath: .MissingKeyBecomesNil, type: PlayerAPIOutputFilters.self)
		media = try json.decode("media", alongPath: .MissingKeyBecomesNil, type: PlayerAPIOutputMedia.self)
		artist = try json.decode("artist", alongPath: .MissingKeyBecomesNil, type: PlayerAPIOutputArtist.self)
		track = try json.decode("track", alongPath: .MissingKeyBecomesNil, type: PlayerAPIOutputMetadata.self)
		next = try json.arrayOf("next", alongPath: .MissingKeyBecomesNil, type: PlayerAPIOutputMetadata.self)
		messages = try json.arrayOf("messages", alongPath: .MissingKeyBecomesNil, type: PlayerAPIOutputMessage.self)
		commands = try json.arrayOf("commands", alongPath: .MissingKeyBecomesNil, type: PlayerAPIOutputCommand.self)
		denied = try json.bool("denied", alongPath: .MissingKeyBecomesNil)
	}
}

extension PlayerAPIOutput: JSONEncodable {
	func toJSON() -> JSON {
		let json: [Swift.String : JSON] = [
			"instance" : instance?.toJSON() ?? JSON.Null,
			"url" : url?.toJSON() ?? JSON.Null,
			"filters" : filters?.toJSON() ?? JSON.Null,
			"media" : media?.toJSON() ?? JSON.Null,
			"artist" : artist?.toJSON() ?? JSON.Null,
			"track" : track?.toJSON() ?? JSON.Null,
			"next" : next?.toJSON() ?? JSON.Null,
			"messages" : messages?.toJSON() ?? JSON.Null,
			"commands" : commands?.toJSON() ?? JSON.Null,
			"denied" : denied?.toJSON() ?? JSON.Null
		]
		return JSON.withoutNullValues(json)
	}
}