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
	override func transition(duration duration: Double, completion: dispatch_block_t? = nil) -> MainPlayerState {
		
		let previousState = _delegate.currentState
		_delegate.mainPlayerStateTransitionBegan(from: previousState, to: self, duration: duration)
		
		_delegate.bottomContainerHeightConstraint.constant = 80.0
		UIView.animateWithDuration(duration, animations: {
			self._delegate.view.layoutIfNeeded()
			self._delegate.nextAvailablMediaContainer.alpha = 0
			self._delegate.longPressInfoContainer.alpha = 0
			self._delegate.compactCurrentTrackContainer.alpha = 1
			self._delegate.subfilterSelectionContainer.alpha = 1
			}) { finished in
				self._delegate.mainPlayerStateTransitionEnded(from: previousState, to: self, duration: duration)
				completion?()
		}
		
		return self
	}
}