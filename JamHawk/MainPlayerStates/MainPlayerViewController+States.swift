//
//  MainPlayerViewController+States.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/18/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension MainPlayerViewController: MainPlayerStateDelegate {
	var parentFilterSelectionViewController: ParentFilterSelectionViewController {
		return _parentFilterSelectionVC
	}
	
	var smallCurrentTrackVotingViewController: CurrentTrackVotingSmallViewController {
		return _smallCurrentTrackVotingVC
	}
	
	var largeCurrentTrackVotingViewController: CurrentTrackVotingLargeViewController {
		return _currentTrackVotingVC
	}
	
	var nextAvailableMediaViewController: NextAvailableMediaViewController {
		return _nextAvailableMediaVC
	}
	
	var playerControlsViewController: PlayerControlsViewController {
		return _playerControlsVC
	}
	
	var subfilterSelectionViewController: SubfilterSelectionViewController {
		return _subfilterSelectionVC
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