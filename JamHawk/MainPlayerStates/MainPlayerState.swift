//
//  MainPlayerState.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/18/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol MainPlayerStateDelegate: class {
	var view: UIView! { get }
	var parentFilterSelectionViewController: ParentFilterSelectionViewController { get }
	var smallCurrentTrackVotingViewController: CurrentTrackVotingSmallViewController { get }
	var largeCurrentTrackVotingViewController: CurrentTrackVotingLargeViewController { get }
	var nextAvailableMediaViewController: NextAvailableMediaViewController { get }
	var playerControlsViewController: PlayerControlsViewController { get }
	var subfilterSelectionViewController: SubfilterSelectionViewController? { get set }
	var bottomContainerHeightConstraint: NSLayoutConstraint { get }
	
	func transition(from fromChildVC: UIViewController?, to toChildVC: UIViewController, completion: dispatch_block_t?)
}

class MainPlayerState: NSObject {
	
	// MARK: - Properties
	internal let _delegate: MainPlayerStateDelegate
	
	init(delegate: MainPlayerStateDelegate) {
		_delegate = delegate
		super.init()
	}
	
	func transition(duration duration: Double) -> MainPlayerState {
		return self
	}
}

class DefaultHomeScreenState: MainPlayerState {
	override func transition(duration duration: Double) -> MainPlayerState {
		_delegate.transition(from: _delegate.smallCurrentTrackVotingViewController, to: _delegate.nextAvailableMediaViewController, completion: nil)
		_delegate.transition(from: _delegate.subfilterSelectionViewController, to: _delegate.largeCurrentTrackVotingViewController) {
			self._delegate.subfilterSelectionViewController = nil
		}
		
		_delegate.parentFilterSelectionViewController.deselectFilters()
		_delegate.bottomContainerHeightConstraint.constant = 150.0
		UIView.animateWithDuration(duration) {
			self._delegate.view.layoutIfNeeded()
		}
		return self
	}
}

class FilterSelectionState: MainPlayerState {
	private let _filter: PlayerAPIOutputFilter
	private let _selectedSubfilters: [PlayerAPIFilterID]
	
	init(delegate: MainPlayerStateDelegate, filter: PlayerAPIOutputFilter, selectedSubfilters: [PlayerAPIFilterID]) {
		_filter = filter
		_selectedSubfilters = selectedSubfilters
		super.init(delegate: delegate)
	}
	
	override func transition(duration duration: Double) -> MainPlayerState {
		
		// If the filter we are trying to transition to for selecting is already , then transition
		// back to the default state
		if let parentFilter = _delegate.subfilterSelectionViewController?.parentFilter where parentFilter == _filter {
			let state = DefaultHomeScreenState(delegate: _delegate)
			return state.transition(duration: duration)
		}
		
		if _delegate.subfilterSelectionViewController?.parentFilter == nil {
			let filterSelectionVC = SubfilterSelectionViewController()
			_delegate.subfilterSelectionViewController = filterSelectionVC
			
			_delegate.transition(from: _delegate.largeCurrentTrackVotingViewController, to: filterSelectionVC, completion: nil)
			_delegate.transition(from: _delegate.nextAvailableMediaViewController, to: _delegate.smallCurrentTrackVotingViewController, completion: nil)
			
			_delegate.bottomContainerHeightConstraint.constant = 80.0
			UIView.animateWithDuration(duration) {
				self._delegate.view.layoutIfNeeded()
			}
		}
		
		_delegate.subfilterSelectionViewController?.update(filter: _filter, selectedSubfilters: _selectedSubfilters)
		_delegate.parentFilterSelectionViewController.scroll(toFilter: _filter)

		return self
	}
}

class VolumeAdjustmentState: MainPlayerState {
	override func transition(duration duration: Double) -> MainPlayerState {
		return self
	}
}

class ShowProfileState: MainPlayerState {
	override func transition(duration duration: Double) -> MainPlayerState {
		return self
	}
}

class ShowNextAvailableMediaDetailsState: MainPlayerState {
}