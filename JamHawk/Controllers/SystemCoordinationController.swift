//
//  SystemCoordinationController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

class SystemCoordinationController {
	
	// deals with the relationships between system controllers
	// talks to JamhawkSession layer
	// handle the API response, feed each respective part to system controllers
	
	let playerSystem = PlayerSystemController()
	let filterSystem = FilterSystemController()
	let currentTrackSystem = CurrentTrackSystemController()
	let nextAvailableSystem = NextAvailableMediaSystemController()
	let ratingSystem = TrackRatingSystemController()
	
	private let _playerAPIService: PlayerAPIService
	
	init(apiService: PlayerAPIService) {
		_playerAPIService = apiService
		playerSystem.delegate = self
	}
	
	func handle(apiOutput output: PlayerAPIOutput) {
		playerSystem.update(withModel: output.media)
		filterSystem.update(withModel: output.filters)
		currentTrackSystem.update(withModel: output.track)
		nextAvailableSystem.update(withModel: output.next)
		nextAvailableSystem.selectMedia(atIndex: 0)
		ratingSystem.update(withModel: output.track)
	}
}

extension SystemCoordinationController: PlayerSystemDelegate {
	func playerSystemNextTrackRequested(system: PlayerSystemController) {
		guard let next = nextAvailableSystem.currentNextTrackSelection else { return }
		
		let updates = PlayerAPIInputUpdates(abandonedRequests: nil, canPlay: true, filter: nil, select: next.mid, ratings: nil)
		_playerAPIService.requestNextTrack(withUpdates: updates) { (error, output) in
			
			guard error == nil else { print(error); return }
			guard let output = output else { print("No output in callback"); return }
			self.handle(apiOutput: output)
		}
	}
}