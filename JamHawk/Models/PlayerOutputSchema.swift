//
//  PlayerAPIOutput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

typealias FilterID = String

enum Rating: JSONEncodable {
	case Negative, Neutral, Positive
	
	var value: Int {
		switch self {
		case .Negative: return -1
		case .Neutral: return 0
		case .Positive: return 1
		}
	}
	
	func toJSON() -> JSON {
		return .Dictionary(["rating" : .Int(value)])
	}
}

enum Event: JSONEncodable {
	case Play, Pause, Resume, End, Skip, PreloadedSkip, Error, Warning
	
	var value: String {
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
		return .Dictionary(["name" : .String(value)])
	}
}

struct Instance {
	let token: String?
	let needPlayerID: Bool
	let needOptions: Bool
	let isMobile: Bool?
	let preloadSync: Bool?
}

struct Status {
	let playerID: String
	let requestID: String
	let needInstance: Bool
	let needMedia: Bool
	let needNext: Bool
	let needFilters: Bool
}

struct FilterSelection {
	let any: Set<FilterID>
}

struct Updates {
	let abandonedRequests: [Int]
	let canPlay: Bool
	let filter: FilterSelection
	let select: Int
	
}

struct Events {
}