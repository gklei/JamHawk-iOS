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

final class MainPlayerViewController: UIViewController, PlayerStoryboardInstantiable {
	
	// MARK: - Outlets
	@IBOutlet private var _backgroundImageView: AsyncImageView!
	
	@IBOutlet internal var _topContainer: UIView!
	@IBOutlet internal var _middleContainer: UIView!
	@IBOutlet internal var _bottomContainer: UIView!
	@IBOutlet internal var _playerControlsContainer: UIView!
	@IBOutlet internal var _subfilterSelectionContainer: UIView!
	@IBOutlet internal var _profileNavigationContainer: UIView!
	@IBOutlet internal var _bottomContainerHeightConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	var playerAPIService: PlayerAPIService?
	var output: PlayerAPIOutput?
	internal var _currentState: MainPlayerState!
	
	internal let _parentFilterSelectionVC = ParentFilterSelectionViewController.create()
	internal let _currentTrackVotingVC = CurrentTrackVotingLargeViewController.create()
	internal let _smallCurrentTrackVotingVC = CurrentTrackVotingSmallViewController.create()
	internal let _nextAvailableMediaVC = NextAvailableMediaViewController.create()
	internal let _playerControlsVC = PlayerControlsViewController.create()
	internal var _subfilterSelectionVC = SubfilterSelectionViewController()
	internal var _profileViewController = ProfileViewController.instantiate(fromStoryboard: "Profile")
	internal let _profileNavController = ProfileNavigationController()
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		add(childViewController: _parentFilterSelectionVC, toContainer: _topContainer)
		add(childViewController: _currentTrackVotingVC, toContainer: _middleContainer)
		add(childViewController: _nextAvailableMediaVC, toContainer: _bottomContainer)
		add(childViewController: _playerControlsVC, toContainer: _playerControlsContainer)
		add(childViewController: _subfilterSelectionVC, toContainer: _subfilterSelectionContainer)
		add(childViewController: _profileNavController, toContainer: _profileNavigationContainer)
		
		_profileNavController.viewControllers = [_profileViewController]
		_parentFilterSelectionVC.selectionClosure = _parentFilterSelected
		_subfilterSelectionVC.viewTappedClosure = _transitionToDefaultState
		_playerControlsVC.delegate = self
		
		let state = DefaultMainPlayerState(delegate: self)
		_currentState = state.transition(duration: 0)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
		removeRightBarItem()
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return _currentState.isKindOfClass(ShowProfileState) ? .Default : .LightContent
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		self.output = output
		
		_currentTrackVotingVC.update(withPlayerAPIOutput: output)
		_nextAvailableMediaVC.update(withPlayerAPIOutput: output)
		_playerControlsVC.update(withPlayerAPIOutput: output)
		_parentFilterSelectionVC.update(withPlayerAPIOutput: output)
		_smallCurrentTrackVotingVC.update(withPlayerAPIOutput: output)
		
		_updateUI(withOutput: output)
	}
	
	// MARK: - Private
	private func _handlePlayerAPICallback(error error: NSError?, output: PlayerAPIOutput?) {
		if let error = error {
			self.present(error)
		}
		
		guard let output = output else { return }
		update(withPlayerAPIOutput: output)
	}
	
	private func _updateUI(withOutput output: PlayerAPIOutput) {
		guard let media = output.media else { return }
		
		let vm = PlayerAPIOutputMediaViewModel(media: media)
		
		let loadImageSelector = #selector(MainPlayerViewController._imageFinishedLoading(_:url:))
		AsyncImageLoader.sharedLoader().cancelLoadingImagesForTarget(_backgroundImageView)
		AsyncImageLoader.sharedLoader().loadImageWithURL(vm.posterURL,
		                                                 target: self,
		                                                 action: loadImageSelector)
	}
	
	private func _transitionToDefaultState() {
		let state = DefaultMainPlayerState(delegate: self)
		_currentState = state.transition(duration: 0.3)
	}
}

// MARK: - Async Image Downloading
extension MainPlayerViewController {
	internal func _imageFinishedLoading(image: UIImage?, url: NSURL?) {
		_backgroundImageView.image = image?.applyBlur(withRadius: 6.0, tintColor: nil, saturationDeltaFactor: 1.3)
	}
}

// MARK: - Filter Selection
extension MainPlayerViewController {
	private func _parentFilterSelected(filter: PlayerAPIOutputFilter) {
		let selectedSubfilters = self.output?.filters?.selected ?? []
		let state = FilterSelectionMainPlayerState(delegate: self, filter: filter, selectedSubfilters: selectedSubfilters)
		_currentState = state.transition(duration: 0.3)
	}
}

// MARK: - Player Controls
extension MainPlayerViewController: PlayerControlsViewControllerDelegate {
	func playerControlsViewController(controller: PlayerControlsViewController, didExecuteAction action: PlayerControlsActionType) {
		switch action {
		case .NextTrack:
			_requestNextTrack()
		case .UserProfile:
			let state = ShowProfileState(delegate: self)
			_currentState = state.transition(duration: 0.3)
			setNeedsStatusBarAppearanceUpdate()
		default: break
		}
	}
}

extension MainPlayerViewController {
	private func _requestNextTrack() {
		let selectedTrack = _nextAvailableMediaVC.selectedTrack?.mid
		let updates = PlayerAPIInputUpdates(abandonedRequests: nil, canPlay: true, filter: nil, select: selectedTrack, ratings: nil)
		playerAPIService?.requestNextTrack(withUpdates: updates, callback: _handlePlayerAPICallback)
	}
}