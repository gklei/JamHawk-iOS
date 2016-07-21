//
//  PlayerAPIInputUpdates.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/11/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

struct PlayerAPIInputUpdates: JSONEncodable {
	let abandonedRequests: [Int]?
	let canPlay: Bool?
	let filter: PlayerAPIInputFilterSelection?
	let select: PlayerAPIMediaID?
	let ratings: PlayerAPIMediaRatings?
	
	func toJSON() -> JSON {
		let json: [String : JSON] = [
			"abandonedRequests" : abandonedRequests?.toJSON() ?? JSON.Null,
			"canPlay" : canPlay?.toJSON() ?? JSON.Null,
			"filter" : filter?.toJSON() ?? JSON.Null,
			"select" : select?.toJSON() ?? JSON.Null,
			"ratings" : ratings?.toJSON() ?? JSON.Null
		]
		return JSON.withoutNullValues(json)
	}
}