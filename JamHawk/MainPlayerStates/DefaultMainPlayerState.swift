//
//  DefaultMainPlayerState.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class DefaultMainPlayerState: MainPlayerState {
	
	// MARK: - Overridden
	override func transition(duration duration: Double) -> MainPlayerState {
		
		_delegate.bottomContainerHeightConstraint.constant = 150.0
		UIView.animateWithDuration(duration) {
			self._delegate.view.layoutIfNeeded()
			self._delegate.nextAvailablMediaContainer.alpha = 1
			self._delegate.subfilterSelectionContainer.alpha = 0
			self._delegate.profileNavigationContainer.alpha = 0
			self._delegate.compactCurrentTrackContainer.alpha = 0
			self._delegate.largeCurrentTrackVotingViewController.setRatingViewControllerHidden(false)
		}
		
		return self
	}
}