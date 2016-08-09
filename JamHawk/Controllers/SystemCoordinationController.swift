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
	* replace the automatic sign in UI with the actual sign in UI
*/

class SystemCoordinationController {
	
	// deals with the relationships between system controllers
	// talks to JamhawkSession layer
	// handle the API response, feed each respective part to system controllers
	
	let playerSystem = PlayerSystem()
	let filterSystem = FilterSystem()
	let currentTrackSystem = CurrentTrackSystem()
	let nextAvailableSystem = NextAvailableMediaSystem()
	let ratingSystem = TrackRatingSystem()
	let eventSystem = EventSystem()
	
	private var _timer: NSTimer?
	private let _playerAPIService: PlayerAPIService
	
	private var _subfilterIDsSinceLastRequest: [PlayerAPIFilterID] = []
	
	var errorPresentationContext: UIViewController?
	
	init(apiService: PlayerAPIService) {
		_playerAPIService = apiService
		
		let sel = #selector(SystemCoordinationController.playerSystemUpdated(_:))
		PlayerSystem.addObserver(self, selector: sel, notification: .modelDidUpdate)
		
		playerSystem.delegate = self
		
		let eventModel: EventSystemNotificationModel = [
			PlayerSystem.nameFor(.play) : .Play,
			PlayerSystem.nameFor(.pause) : .Pause,
			PlayerSystem.nameFor(.resume) : .Resume,
			PlayerSystem.nameFor(.skip) : .Skip,
			PlayerSystem.nameFor(.end) : .End,
			PlayerSystem.nameFor(.preloadedSkip) : .PreloadedSkip,
			PlayerSystem.nameFor(.error) : .Error,
			PlayerSystem.nameFor(.warning) : .Warning,
		]
		eventSystem.update(withModel: eventModel)
	}
	
	private func _handlePlayerAPICallback(error: NSError?, output: PlayerAPIOutput?) {
		if let error = error {
			errorPresentationContext?.present(error)
		}
		
		guard let output = output else { return }
		playerSystem.update(withModel: output.media)
		
		if output.filters != nil {
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
	
	var playerSystemCurrentTrackMID: PlayerAPIMediaID? {
		return currentTrackSystem.currentMID
	}
}

extension SystemCoordinationController {
	
	private func _setupRequestTimer(withInterval seconds: NSTimeInterval) {
		guard _timer == nil else { return }
		
		let fireDate = NSDate(timeIntervalSinceNow: 3)
		let selector = #selector(sendRequestToPlayerAPI(_:))
		_timer = NSTimer(fireDate: fireDate, interval: seconds, target: self, selector: selector, userInfo: nil, repeats: true)
		NSRunLoop.mainRunLoop().addTimer(_timer!, forMode: NSDefaultRunLoopMode)
	}
	
	@objc internal func sendRequestToPlayerAPI(timer: NSTimer? = nil) {
		let filterSelection = _generateFilterSelectionIfChanged()
		let next = nextAvailableSystem.currentNextTrackSelection?.mid
		
		let events = eventSystem.dequeueEvents()
		eventSystem.clearEvents()
		
		let updates = PlayerAPIInputUpdates(abandonedRequests: nil,
		                                    canPlay: true,
		                                    filter: filterSelection,
		                                    select: next,
		                                    ratings: nil)
		
		let needNext = (filterSelection != nil) || playerSystem.wantsToAdvance
		_playerAPIService.sendRequest(needNext: needNext,
		                              needMedia: playerSystem.wantsToAdvance,
		                              needFilters: false,
		                              updates: updates,
		                              events: events,
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

extension SystemCoordinationController {
	@objc func playerSystemUpdated(notification: NSNotification) {
		if playerSystem.wantsToAdvance {
			_killRequestTimer()
			sendRequestToPlayerAPI()
			playerSystem.wantsToAdvance = false
			_setupRequestTimer(withInterval: 3.0)
		}
	}
	
	private func _killRequestTimer() {
		_timer?.invalidate()
		_timer = nil
	}
}