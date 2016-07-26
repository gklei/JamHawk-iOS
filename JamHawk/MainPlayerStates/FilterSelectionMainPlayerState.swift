//
//  File.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class FilterSelectionMainPlayerState: MainPlayerState {
	
	// MARK: - Overridden
	override func transition(duration duration: Double) -> MainPlayerState {
		
		_delegate.bottomContainerHeightConstraint.constant = 80.0
		UIView.animateWithDuration(duration) {
			self._delegate.view.layoutIfNeeded()
			self._delegate.nextAvailablMediaContainer.alpha = 0
			self._delegate.compactCurrentTrackContainer.alpha = 1
			self._delegate.subfilterSelectionContainer.alpha = 1
			self._delegate.largeCurrentTrackVotingViewController.setRatingViewControllerHidden(true)
		}
		
		return self
	}
}