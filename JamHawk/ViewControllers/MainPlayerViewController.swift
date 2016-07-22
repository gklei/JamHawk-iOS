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
	
	@IBOutlet private var _topContainer: UIView!
	@IBOutlet private var _middleContainer: UIView!
	@IBOutlet private var _bottomContainer: UIView!
	@IBOutlet private var _playerControlsContainer: UIView!
	@IBOutlet internal var _subfilterSelectionContainer: UIView!
	
	@IBOutlet internal var _bottomContainerHeightConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	var playerAPIService: PlayerAPIService?
	var output: PlayerAPIOutput?
	private var _currentState: MainPlayerState!
	
	internal let _parentFilterSelectionVC = ParentFilterSelectionViewController.create()
	internal let _currentTrackVotingVC = CurrentTrackVotingLargeViewController.create()
	internal let _smallCurrentTrackVotingVC = CurrentTrackVotingSmallViewController.create()
	internal let _nextAvailableMediaVC = NextAvailableMediaViewController.create()
	internal let _playerControlsVC = PlayerControlsViewController.create()
	internal var _subfilterSelectionVC = SubfilterSelectionViewController()
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		add(childViewController: _parentFilterSelectionVC, toContainer: _topContainer)
		add(childViewController: _currentTrackVotingVC, toContainer: _middleContainer)
		add(childViewController: _nextAvailableMediaVC, toContainer: _bottomContainer)
		add(childViewController: _playerControlsVC, toContainer: _playerControlsContainer)
		add(childViewController: _subfilterSelectionVC, toContainer: _subfilterSelectionContainer)
		
//		// Load views that don't show initially
		let _ = _smallCurrentTrackVotingVC.view
		let _ = _subfilterSelectionVC.view
		
		_parentFilterSelectionVC.selectionClosure = _parentFilterSelected
		_playerControlsVC.delegate = self
		
		let state = DefaultHomeScreenState(delegate: self)
		_currentState = state.transition(duration: 0)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
		removeRightBarItem()
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
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
		
		AsyncImageLoader.sharedLoader().cancelLoadingImagesForTarget(_backgroundImageView)
		AsyncImageLoader.sharedLoader().loadImageWithURL(vm.posterURL, target: self, action: #selector(MainPlayerViewController._imageFinishedLoading(_:url:)))
	}
	
	internal func _imageFinishedLoading(image: UIImage?, url: NSURL?) {
		guard let image = image else { return }
		
		_backgroundImageView.image = image.applyBlur(withRadius: 6.0, tintColor: nil, saturationDeltaFactor: 1)
	}
}

// MARK: - Filter Selection
extension MainPlayerViewController {
	private func _parentFilterSelected(filter: PlayerAPIOutputFilter) {
		let selectedSubfilters = self.output?.filters?.selected ?? []
		let state = FilterSelectionState(delegate: self, filter: filter, selectedSubfilters: selectedSubfilters)
		_currentState = state.transition(duration: 0.2)
	}
}

// MARK: - Player Controls
extension MainPlayerViewController: PlayerControlsViewControllerDelegate {
	func playerControlsViewController(controller: PlayerControlsViewController, didExecuteAction action: PlayerControlsActionType) {
		if action == .NextTrack {
			_requestNextTrack()
		}
	}
}

extension MainPlayerViewController {
	private func _requestNextTrack() {
		var updates: PlayerAPIInputUpdates?
		if let selectedTrack = _nextAvailableMediaVC.selectedTrack {
			updates = PlayerAPIInputUpdates(abandonedRequests: nil, canPlay: true, filter: nil, select: selectedTrack.mid, ratings: nil)
		}
		
		playerAPIService?.requestNextTrack(withUpdates: updates, callback: _handlePlayerAPICallback)
	}
}