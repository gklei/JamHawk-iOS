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
	var subfilterSelectionViewController: SubfilterSelectionViewController { get }
	var smallCurrentTrackVotingViewController: CurrentTrackVotingSmallViewController { get }
	var largeCurrentTrackVotingViewController: CurrentTrackVotingLargeViewController { get }
	var nextAvailableMediaViewController: NextAvailableMediaViewController { get }
	var playerControlsViewController: PlayerControlsViewController { get }
	var profileViewController: ProfileViewController { get }
	
	var bottomContainer: UIView! { get }
	var middleContainer: UIView! { get }
	var subfilterSelectionContainer: UIView! { get }
	var profileNavigationContainer: UIView! { get }
	
	var profileNavigationController: UINavigationController { get }
	var bottomContainerHeightConstraint: NSLayoutConstraint { get }
	
	var currentState: MainPlayerState { get }
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
