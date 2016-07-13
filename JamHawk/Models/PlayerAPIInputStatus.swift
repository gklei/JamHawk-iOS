//
//  PlayerAPIInputStatus.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/11/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

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
	
	// MARK: - Testing
	static func requestNextTrackStatus(playerID: String) -> PlayerAPIInputStatus {
		return PlayerAPIInputStatus(playerID: playerID, requestID: 0, needInstance: false, needMedia: true, needNext: true, needFilters: true)
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