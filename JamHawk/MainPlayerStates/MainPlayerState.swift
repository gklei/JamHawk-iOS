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
	var playerFiltersViewController: PlayerFiltersViewController { get }
	var smallCurrentTrackVotingViewController: CurrentTrackVotingSmallViewController { get }
	var largeCurrentTrackVotingViewController: CurrentTrackVotingLargeViewController { get }
	var nextAvailableMediaViewController: NextAvailableMediaViewController { get }
	var playerControlsViewController: PlayerControlsViewController { get }
	var filterSelectionViewController: FilterSelectionViewController? { get set }
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
		_delegate.transition(from: _delegate.filterSelectionViewController, to: _delegate.largeCurrentTrackVotingViewController) {
			self._delegate.filterSelectionViewController = nil
		}
		
		_delegate.playerFiltersViewController.deselectFilters()
		_delegate.bottomContainerHeightConstraint.constant = 124.0
		UIView.animateWithDuration(duration) {
			self._delegate.view.layoutIfNeeded()
		}
		return self
	}
}

class FilterSelectionState: MainPlayerState {
	private let _filter: PlayerAPIOutputFilter
	
	init(delegate: MainPlayerStateDelegate, filter: PlayerAPIOutputFilter) {
		_filter = filter
		super.init(delegate: delegate)
	}
	
	override func transition(duration duration: Double) -> MainPlayerState {
		
		// If the filter we are trying to transition to for selecting is already , then transition
		// back to the default state
		if let parentFilter = _delegate.filterSelectionViewController?.parentFilter where parentFilter == _filter {
			let state = DefaultHomeScreenState(delegate: _delegate)
			return state.transition(duration: duration)
		}
		
		if _delegate.filterSelectionViewController?.parentFilter == nil {
			let filterSelectionVC = FilterSelectionViewController()
			_delegate.filterSelectionViewController = filterSelectionVC
			
			_delegate.transition(from: _delegate.largeCurrentTrackVotingViewController, to: filterSelectionVC, completion: nil)
			_delegate.transition(from: _delegate.nextAvailableMediaViewController, to: _delegate.smallCurrentTrackVotingViewController, completion: nil)
			
			_delegate.bottomContainerHeightConstraint.constant = 80.0
			UIView.animateWithDuration(duration) {
				self._delegate.view.layoutIfNeeded()
			}
		}
		
		_delegate.filterSelectionViewController?.update(filter: _filter)
		_delegate.playerFiltersViewController.scroll(toFilter: _filter)

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