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
		
		_playerFiltersVC.update(withPlayerAPIOutput: output)
		_currentTrackVotingVC.update(withPlayerAPIOutput: output)
		_nextAvailableMediaVC.update(withPlayerAPIOutput: output)
		_playerControlsVC.update(withPlayerAPIOutput: output)
		
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
		var transitioningToFilterSelection = _filterSelectionVC == nil
		
		if transitioningToFilterSelection {
			let filterSelectionVC = FilterSelectionViewController(filter: filter)
			transition(from: _currentTrackVotingVC, to: filterSelectionVC, usingContainer: _middleContainer)
			transition(from: _nextAvailableMediaVC, to: _smallCurrentTrackVotingVC, usingContainer: _bottomContainer)
			
			_filterSelectionVC = filterSelectionVC
			_playerFiltersVC.scroll(toFilter: filter)
		} else {
			if let currentFilter = _filterSelectionVC?.currentFilter where currentFilter != filter {
				_filterSelectionVC?.update(filter: filter)
				_playerFiltersVC.scroll(toFilter: filter)
				transitioningToFilterSelection = true
			} else {
				transition(from: _smallCurrentTrackVotingVC, to: _nextAvailableMediaVC, usingContainer: _bottomContainer)
				transition(from: _filterSelectionVC, to: _currentTrackVotingVC, usingContainer: _middleContainer) {
					self._filterSelectionVC = nil
				}
				_playerFiltersVC.deselectFilters()
			}
		}
		
		let bottomContainerHeight: CGFloat = transitioningToFilterSelection ? 80 : 124
		_bottomContainerHeightConstraint.constant = bottomContainerHeight
		UIView.animateWithDuration(0.2) {
			self.view.layoutIfNeeded()
		}
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