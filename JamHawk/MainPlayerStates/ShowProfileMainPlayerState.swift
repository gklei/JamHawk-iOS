//
//  ShowProfileMainPlayerState.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ShowProfileState: MainPlayerState {
	
	// MARK: - Overridden
	override func transition(duration duration: Double) -> MainPlayerState {
		
		guard !_delegate.currentState.isKindOfClass(self.dynamicType) else {
			let state = DefaultMainPlayerState(delegate: _delegate)
			return state.transition(duration: duration)
		}
		
		_delegate.bottomContainerHeightConstraint.constant = 80.0
		UIView.animateWithDuration(duration) {
			self._delegate.nextAvailablMediaContainer.alpha = 0
			self._delegate.compactCurrentTrackContainer.alpha = 1
			self._delegate.profileNavigationContainer.alpha = 1
			self._delegate.view.layoutIfNeeded()
		}

		return self
	}
}
