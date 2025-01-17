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
	
	let playerSystem = PlayerSystem()
	let filterSystem = FilterSystem()
	let currentTrackSystem = CurrentTrackSystem()
	let nextAvailableSystem = NextAvailableMediaSystem()
	let ratingSystem = TrackRatingSystem()
	let eventSystem = EventSystem()
	
	private var _timer: NSTimer?
	private let _playerAPIService: PlayerAPIService
	
	private var _playerInstantiationFilterSelection: PlayerAPIFilterSelection?
	private var _subfilterIDsSinceLastRequest: [PlayerAPIFilterID] = []
	
	var errorPresentationContext: UIViewController?
	
	init(apiService: PlayerAPIService) {
		_playerAPIService = apiService
		
		let playerUpdatedSel = #selector(SystemCoordinationController.playerSystemUpdated(_:))
		PlayerSystem.addObserver(self, selector: playerUpdatedSel, notification: .modelDidUpdate)
		
		let parentFilterSelectedChangedSel = #selector(SystemCoordinationController.parentFilterChanged(_:))
		FilterSystem.addObserver(self, selector: parentFilterSelectedChangedSel, notification: .parentFilterSelectionDidUpdate)
		
		let dataExistsSel = #selector(SystemCoordinationController.dataExistsForAPI(_:))
		EventSystem.addObserver(self, selector: dataExistsSel, notification: .didQueueEvent)
		FilterSystem.addObserver(self, selector: dataExistsSel, notification: .subfilterSelectionDidUpdate)
		TrackRatingSystem.addObserver(self, selector: dataExistsSel, notification: .modelDidUpdate)
		
		let ratingSystemUpdatedSel = #selector(SystemCoordinationController.ratingSystemUpdated(_:))
		TrackRatingSystem.addObserver(self, selector: ratingSystemUpdatedSel, notification: .modelDidUpdate)
		
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
		currentTrackSystem.update(withModel: output.track)
		playerSystem.update(withModel: output.media)
		
		if output.filters != nil {
			filterSystem.update(withModel: output.filters)
		}
		
		if output.next != nil {
			nextAvailableSystem.update(withModel: output.next)
			nextAvailableSystem.selectMedia(atIndex: 0)
		}
		
		ratingSystem.update(withModel: output.track)
	}
	
	func instantiatePlayer(filterSelection filterSelection: PlayerAPIInputFilterSelection? = nil,
	                                       completion: ((error: NSError?) -> Void)?) {
		
		if let ids = filterSelection?.selection.values.flatten().flatMap({$0}) {
			filterSystem.initialSelection = ids
			_subfilterIDsSinceLastRequest = ids
		}
		
		_playerAPIService.instantiatePlayer(filterSelection: filterSelection) { (error, output) in
			self._handlePlayerAPICallback(error, output: output)
			completion?(error: error)
		}
	}
	
	func killPlayer() {
		_killRequestTimer()
		playerSystem.pause()
	}
}

extension SystemCoordinationController: PlayerSystemDelegate {
	
	var playerSystemCurrentTrackMID: PlayerAPIMediaID? {
		return currentTrackSystem.currentMID
	}
}

extension SystemCoordinationController {
	
	private func _startRequestTimer(withDelay seconds: NSTimeInterval) {
		let fireDate = NSDate(timeIntervalSinceNow: seconds)
		let selector = #selector(sendRequestToPlayerAPI(_:))
		_timer = NSTimer(fireDate: fireDate, interval: seconds, target: self, selector: selector, userInfo: nil, repeats: false)
		NSRunLoop.mainRunLoop().addTimer(_timer!, forMode: NSDefaultRunLoopMode)
	}
	
	@objc internal func sendRequestToPlayerAPI(timer: NSTimer? = nil) {
		let filterSelection = _generateFilterSelectionIfChanged()
		let next = nextAvailableSystem.currentNextTrackSelection?.mid
		let ratings = ratingSystem.currentRatings
		let events = eventSystem.dequeueEvents()
		
		let updates = PlayerAPIInputUpdates(abandonedRequests: nil,
		                                    canPlay: true,
		                                    filter: filterSelection,
		                                    select: next,
		                                    ratings: ratings)
		
		let needNext = (filterSelection != nil) || playerSystem.wantsToAdvance
		_playerAPIService.sendRequest(needNext: needNext,
		                              needMedia: playerSystem.wantsToAdvance,
		                              needFilters: false,
		                              updates: updates,
		                              events: events,
		                              callback: _handlePlayerAPICallback)
		_killRequestTimer()
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
		}
	}
	
	@objc func parentFilterChanged(notification: NSNotification) {
		_killRequestTimer()
		sendRequestToPlayerAPI()
	}
	
	@objc func dataExistsForAPI(notification: NSNotification) {
		guard _timer == nil else { return }
		_startRequestTimer(withDelay: 3.0)
	}
	
	@objc func ratingSystemUpdated(notification: NSNotification) {
		if let rating = ratingSystem.currentTrackRating where rating == .Negative {
			playerSystem.wantsToAdvance = true
			_killRequestTimer()
			sendRequestToPlayerAPI()
			playerSystem.wantsToAdvance = false
		}
	}
	
	private func _killRequestTimer() {
		_timer?.invalidate()
		_timer = nil
	}
}