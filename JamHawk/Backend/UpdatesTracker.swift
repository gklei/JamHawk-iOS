//
//  File.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/21/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

/*
	When the user is interacting with the main player, there are two key points:
	1. Updates to the player are being made (e.g. filter selection)
	2. Status updates are being made (needsMedia = true)

	We need to regulate calls being made to the server by using an interval for server updates. We'll track events
	that are triggered by the user (treating the 'next_track' event as a special case)
*/

/*
	Status
		playerID - X
		requestID - X
		needInstance - false
		needMedia - gets set to true when the user requests the next track
		needNext - gets set to true when the filter selection changes
		needFilters - flase

	Updates
		filter - null means that there are no updates
		select - next song id
		ratings - queued up

*/

/*
Status:
	let playerID: String
	let requestID: Int
	let needInstance: Bool
	let needMedia: Bool
	let needNext: Bool
	let needFilters: Bool

Updates:
	let abandonedRequests: [Int]?
	let canPlay: Bool?
	let filter: PlayerAPIInputFilterSelection?
	let select: PlayerAPIMediaID?
	let ratings: PlayerAPIMediaRatings?
*/

class UpdatesTracker {
	
}