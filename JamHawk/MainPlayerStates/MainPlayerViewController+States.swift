//
//  MainPlayerViewController+States.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/18/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension MainPlayerViewController: MainPlayerStateDelegate {
	var largeCurrentTrackVotingViewController: LargeCurrentTrackViewController {
		return _largeCurrentTrackVC
	}
	
	var bottomContainerHeightConstraint: NSLayoutConstraint {
		return _bottomContainerHeightConstraint
	}
	
	var subfilterSelectionContainer: UIView! {
		return _subfilterSelectionContainer
	}
	
	var compactCurrentTrackContainer: UIView! {
		return _compactCurrentTrackContainer
	}
	
	var nextAvailablMediaContainer: UIView! {
		return _nextAvailableMediaContainer
	}
	
	var profileNavigationController: UINavigationController {
		return _profileNavController
	}
	
	var profileViewController: ProfileViewController {
		return _profileViewController
	}
	
	var profileNavigationContainer: UIView! {
		return _profileNavigationContainer
	}
	
	var middleContainer: UIView! {
		return _middleContainer
	}
	
	var currentState: MainPlayerState {
		return _currentState
	}
}