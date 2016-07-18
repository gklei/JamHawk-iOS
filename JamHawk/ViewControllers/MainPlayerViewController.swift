//
//  MainPlayerViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AVFoundation
import AsyncImageView
import IncipiaKit

class MainPlayerViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private var _backgroundImageView: AsyncImageView!
	
	@IBOutlet private var _topContainer: UIView!
	@IBOutlet private var _middleContainer: UIView!
	@IBOutlet private var _bottomContainer: UIView!
	@IBOutlet private var _playerControlsContainer: UIView!
	
	@IBOutlet private var _bottomContainerHeightConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	var output: PlayerAPIOutput?
	private var _currentState: MainPlayerState!
	
	private let _playerFiltersVC = PlayerFiltersViewController.instantiate(fromStoryboard: "Player")
	private let _currentTrackVotingVC = CurrentTrackVotingLargeViewController.instantiate(fromStoryboard: "Player")
	private let _smallCurrentTrackVotingVC = CurrentTrackVotingSmallViewController.instantiate(fromStoryboard: "Player")
	private let _nextAvailableMediaVC = NextAvailableMediaViewController.instantiate(fromStoryboard: "Player")
	private let _playerControlsVC = PlayerControlsViewController.instantiate(fromStoryboard: "Player")
	private var _filterSelectionVC: FilterSelectionViewController?
	
	var nextTrackButtonPressed: () -> Void = {}
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		add(childViewController: _playerFiltersVC, toContainer: _topContainer)
		add(childViewController: _currentTrackVotingVC, toContainer: _middleContainer)
		add(childViewController: _nextAvailableMediaVC, toContainer: _bottomContainer)
		add(childViewController: _playerControlsVC, toContainer: _playerControlsContainer)
		
		_playerFiltersVC.selectionClosure = _filterSelected
		_playerControlsVC.delegate = self
		
		_currentState = DefaultHomeScreenState(delegate: self)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
		removeRightBarItem()
		_setupTitleView()
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	// MARK: - Setup
	private func _setupTitleView() {
		let titleViewFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 40)
		let titleView = JamhawkTitleViewController().view
		titleView.frame = titleViewFrame
		navigationItem.titleView = titleView
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		self.output = output
		
		_currentTrackVotingVC.update(withPlayerAPIOutput: output)
		_nextAvailableMediaVC.update(withPlayerAPIOutput: output)
		_playerControlsVC.update(withPlayerAPIOutput: output)
		
		if _filterSelectionVC == nil {
			_playerFiltersVC.update(withPlayerAPIOutput: output)
		}
		
		let _ = _smallCurrentTrackVotingVC.view
		_smallCurrentTrackVotingVC.update(withPlayerAPIOutput: output)
		
		_updateUI(withOutput: output)
	}
	
	// MARK: - Private
	private func _updateUI(withOutput output: PlayerAPIOutput) {
		guard let media = output.media else { return }
		
		let vm = PlayerAPIOutputMediaViewModel(media: media)
		_backgroundImageView.imageURL = vm.posterURL
	}
}

// MARK: - Filter Selection
extension MainPlayerViewController {
	private func _filterSelected(filter: PlayerAPIOutputFilter) {
		let state = FilterSelectionState(delegate: self, filter: filter)
		_currentState = state.transition(duration: 0.2)
	}
}

// MARK: - Player Controls
extension MainPlayerViewController: PlayerControlsViewControllerDelegate {
	func playerControlsViewController(controller: PlayerControlsViewController, didExecuteAction action: PlayerControlsActionType) {
		if action == .NextTrack {
			nextTrackButtonPressed()
		}
	}
}

extension MainPlayerViewController: MainPlayerStateDelegate {
	var currentState: MainPlayerState {
		return _currentState
	}
	var playerFiltersViewController: PlayerFiltersViewController {
		return _playerFiltersVC
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
	var filterSelectionViewController: FilterSelectionViewController? {
		get {
			return _filterSelectionVC
		}
		set {
			_filterSelectionVC = newValue
		}
	}
	var bottomContainerHeightConstraint: NSLayoutConstraint {
		return _bottomContainerHeightConstraint
	}
}