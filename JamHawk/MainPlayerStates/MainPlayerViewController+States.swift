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
	
	var filterSelectionViewController: SubfilterSelectionViewController? {
		get {
			return _subfilterSelectionVC
		} set {
			_subfilterSelectionVC = newValue
		}
	}
	
	var bottomContainerHeightConstraint: NSLayoutConstraint {
		return _bottomContainerHeightConstraint
	}
}