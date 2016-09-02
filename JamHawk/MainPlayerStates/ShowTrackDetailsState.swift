//
//  ShowTrackDetailsState.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ShowTrackDetailsState: MainPlayerState {
	override func transition(duration duration: Double, completion: dispatch_block_t?) -> MainPlayerState {
		
		let previousState = _delegate.currentState
		_delegate.mainPlayerStateTransitionBegan(from: previousState, to: self, duration: duration)
		
		let constant = UIScreen.mainScreen().bounds.height * 0.2
		_delegate.bottomContainerHeightConstraint.constant = ceil(constant)
		UIView.animateWithDuration(duration, animations: {
			self._delegate.view.layoutIfNeeded()
			self._delegate.longPressInfoContainer.alpha = 1
			self._delegate.nextAvailablMediaContainer.alpha = 1
			self._delegate.subfilterSelectionContainer.alpha = 0
			self._delegate.profileNavigationContainer.alpha = 0
			self._delegate.compactCurrentTrackContainer.alpha = 0
			self._delegate.largeCurrentTrackVotingViewController.setRatingViewControllerHidden(false)
		}) { finished in
			self._delegate.mainPlayerStateTransitionEnded(from: previousState, to: self, duration: duration)
			completion?()
		}
		
		return self
	}
}
