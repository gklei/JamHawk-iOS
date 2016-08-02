//
//  SystemCoordinationController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

/*
   Prioritized tasks
	* download media files
	* automatically play the next song when the current song ends
	* change the UI for anything that doesn't look right
	* replace the automatic sign in UI with the actual sign in UI
*/

class SystemCoordinationController {
	
	// deals with the relationships between system controllers
	// talks to JamhawkSession layer
	// handle the API response, feed each respective part to system controllers
	
	let playerSystem = PlayerSystemController()
	let filterSystem = FilterSystem()
	let currentTrackSystem = CurrentTrackSystemController()
	let nextAvailableSystem = NextAvailableMediaSystemController()
	let ratingSystem = TrackRatingSystemController()
	
	private var _timer: NSTimer?
	private let _playerAPIService: PlayerAPIService
	
	private var _subfilterIDsSinceLastRequest: [PlayerAPIFilterID] = []
	
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
		
		if output.filters != nil {
//			print(output.filters!)
			filterSystem.update(withModel: output.filters)
		}
		
		currentTrackSystem.update(withModel: output.track)
		
		if output.next != nil {
			nextAvailableSystem.update(withModel: output.next)
			nextAvailableSystem.selectMedia(atIndex: 0)
		}
		
		ratingSystem.update(withModel: output.track)
	}
	
	func instantiatePlayer(completion: ((error: NSError?) -> Void)?) {
		_playerAPIService.instantiatePlayer { (error, output) in
			self._handlePlayerAPICallback(error, output: output)
			
			completion?(error: error)
			self._setupRequestTimer(withInterval: 3)
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

extension SystemCoordinationController {
	
	/*
		When something happens that isn't immediate, set up a timer
		When something more immediate happens, replace the timer
	*/
	
	private func _setupRequestTimer(withInterval seconds: NSTimeInterval) {
		guard _timer == nil else { return }
		
		let fireDate = NSDate(timeIntervalSinceNow: 3)
		let selector = #selector(_sendRequestToPlayerAPI(_:))
		_timer = NSTimer(fireDate: fireDate, interval: seconds, target: self, selector: selector, userInfo: nil, repeats: true)
		NSRunLoop.mainRunLoop().addTimer(_timer!, forMode: NSDefaultRunLoopMode)
	}
	
	@objc internal func _sendRequestToPlayerAPI(timer: NSTimer) {
		
		let filterSelection = _generateFilterSelectionIfChanged()
		let next = nextAvailableSystem.currentNextTrackSelection?.mid
		
		// gather events using the event queue (clear queue right after we send)
		// get song rating information (use request id)
		
		let updates = PlayerAPIInputUpdates(abandonedRequests: nil,
		                                    canPlay: true,
		                                    filter: filterSelection,
		                                    select: next,
		                                    ratings: nil)
		
		_playerAPIService.sendRequest(needNext: (filterSelection != nil),
		                              needMedia: false,
		                              needFilters: false,
		                              updates: updates,
		                              callback: _handlePlayerAPICallback)
	}
	
	private func _generateFilterSelectionIfChanged() -> PlayerAPIInputFilterSelection? {
		var selection: PlayerAPIInputFilterSelection?
		let currentSelectedSubfilterIDs = filterSystem.selectedSubfilterIDs
		
		// TODO: use the request ID at the time the request is sent and at the time that it's received to determine
		// whether the server is in sync with the client
		if _subfilterIDsSinceLastRequest != currentSelectedSubfilterIDs {
			_subfilterIDsSinceLastRequest = currentSelectedSubfilterIDs
			selection = PlayerAPIInputFilterSelection(selection: filterSystem.filterSelection)
		}
		return selection
	}
}