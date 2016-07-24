//
//  File.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class FilterSelectionMainPlayerState: MainPlayerState {
	
	// MARK: - Properties
	private let _filter: PlayerAPIOutputFilter
	private let _selectedSubfilters: [PlayerAPIFilterID]
	
	// MARK: - Init
	init(delegate: MainPlayerStateDelegate, filter: PlayerAPIOutputFilter, selectedSubfilters: [PlayerAPIFilterID]) {
		_filter = filter
		_selectedSubfilters = selectedSubfilters
		super.init(delegate: delegate)
	}
	
	// MARK: - Overridden
	override func transition(duration duration: Double) -> MainPlayerState {
		
		// If the filter we are trying to transition to for selecting is already selected, then transition
		// back to the default state
		if _delegate.subfilterSelectionViewController.parentFilter == _filter {
			let state = DefaultMainPlayerState(delegate: _delegate)
			return state.transition(duration: duration)
		}
		
		if _delegate.subfilterSelectionViewController.parentFilter == nil {
			_delegate.transition(from: _delegate.nextAvailableMediaViewController,
			                     to: _delegate.smallCurrentTrackVotingViewController,
			                     completion: nil)
			
			_delegate.bottomContainerHeightConstraint.constant = 80.0
			UIView.animateWithDuration(duration) {
				self._delegate.view.layoutIfNeeded()
				self._delegate.subfilterSelectionContainer.alpha = 1
				self._delegate.largeCurrentTrackVotingViewController.setVotingButtonsHidden(true)
			}
		}
		
		_delegate.subfilterSelectionViewController.update(filter: _filter, selectedSubfilters: _selectedSubfilters)
		_delegate.parentFilterSelectionViewController.scroll(toFilter: _filter)
		
		return self
	}
}