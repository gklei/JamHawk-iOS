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
	
	var largeCurrentTrackVotingViewController: LargeCurrentTrackViewController { get }
	
	var middleContainer: UIView! { get }
	var subfilterSelectionContainer: UIView! { get }
	var profileNavigationContainer: UIView! { get }
	
	var profileNavigationController: UINavigationController { get }
	var bottomContainerHeightConstraint: NSLayoutConstraint { get }
	
	var compactCurrentTrackContainer: UIView! { get }
	var nextAvailablMediaContainer: UIView! { get }
	
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
