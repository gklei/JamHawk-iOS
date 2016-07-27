//
//  SystemCoordinationController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

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
	
	var errorPresentationContext: UIViewController?
	
	init(apiService: PlayerAPIService) {
		_playerAPIService = apiService
		playerSystem.delegate = self
	}
	
	private func _handlePlayerAPICallback(error: NSError?, output: PlayerAPIOutput?) {
		if let error = error {
			errorPresentationContext?.present(error)
		}
		
		guard let output = output else { return }
		
		playerSystem.update(withModel: output.media)
		filterSystem.update(withModel: output.filters)
		currentTrackSystem.update(withModel: output.track)
		nextAvailableSystem.update(withModel: output.next)
		nextAvailableSystem.selectMedia(atIndex: 0)
		ratingSystem.update(withModel: output.track)
	}
	
	func instantiatePlayer(callback: PlayerAPICallback) {
		_playerAPIService.instantiatePlayer { (error, output) in
			self._handlePlayerAPICallback(error, output: output)
			callback(error: error, output: output)
		}
	}
}

extension SystemCoordinationController: PlayerSystemDelegate {
	func playerSystemNextTrackRequested(system: PlayerSystemController) {
		guard let next = nextAvailableSystem.currentNextTrackSelection else { return }
		
		let updates = PlayerAPIInputUpdates(abandonedRequests: nil, canPlay: true, filter: nil, select: next.mid, ratings: nil)
		_playerAPIService.requestNextTrack(withUpdates: updates, callback: _handlePlayerAPICallback)
	}
}