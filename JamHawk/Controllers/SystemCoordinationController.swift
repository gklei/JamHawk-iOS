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
	
	private let _playerSystem: PlayerSystemController
	private let _filterSystem: FilterSystemController
	private let _currentTrackSystem: CurrentTrackSystemController
	private let _nextAvailableSystem: NextAvailableMediaSystemController
	private let _ratingSystem: TrackRatingSystemController
	
	// TAKE THIS OUT!
	var currentNextTrack: PlayerAPIOutputMetadata? {
		return _nextAvailableSystem.currentNextTrackSelection
	}
	
	init(playerSystem: PlayerSystemController,
	     filterSystem: FilterSystemController,
	     currentTrackSystem: CurrentTrackSystemController,
	     nextAvailableSystem: NextAvailableMediaSystemController,
	     ratingSystem: TrackRatingSystemController) {
		_playerSystem = playerSystem
		_filterSystem = filterSystem
		_currentTrackSystem = currentTrackSystem
		_nextAvailableSystem = nextAvailableSystem
		_ratingSystem = ratingSystem
	}
	
	func handle(apiOutput output: PlayerAPIOutput) {
		_playerSystem.update(withModel: output.media)
		_filterSystem.update(withModel: output.filters)
		_currentTrackSystem.update(withModel: output.track)
		
		_nextAvailableSystem.update(withModel: output.next)
		_nextAvailableSystem.selectMedia(atIndex: 0)
		
		_ratingSystem.update(withModel: output.track)
	}
}