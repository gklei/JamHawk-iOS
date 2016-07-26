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
	
	@IBOutlet internal var _compactCurrentTrackContainer: UIView!
	@IBOutlet internal var _nextAvailableMediaContainer: UIView!
	
	@IBOutlet internal var _playerControlsContainer: UIView!
	@IBOutlet internal var _subfilterSelectionContainer: UIView!
	@IBOutlet internal var _profileNavigationContainer: UIView!
	@IBOutlet internal var _bottomContainerHeightConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	var playerAPIService: PlayerAPIService?
	var output: PlayerAPIOutput?
	internal var _currentState: MainPlayerState!
	
	internal let _parentFilterSelectionVC = ParentFilterSelectionViewController.create()
	internal let _largeCurrentTrackVC = LargeCurrentTrackViewController.create()
	internal let _compactCurrentTrackVC = CompactCurrentTrackViewController.create()
	internal let _nextAvailableMediaVC = NextAvailableMediaViewController.create()
	internal let _playerControlsVC = PlayerControlsViewController.create()
	internal var _subfilterSelectionVC = SubfilterSelectionViewController()
	internal var _profileViewController = ProfileViewController.instantiate(fromStoryboard: "Profile")
	internal let _profileNavController = ProfileNavigationController()
	
	// MARK: - System Controllers
	private var _coordinationController: SystemCoordinationController?
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		add(childViewController: _parentFilterSelectionVC, toContainer: _topContainer)
		add(childViewController: _largeCurrentTrackVC, toContainer: _middleContainer)
		add(childViewController: _nextAvailableMediaVC, toContainer: _nextAvailableMediaContainer)
		add(childViewController: _compactCurrentTrackVC, toContainer: _compactCurrentTrackContainer)
		add(childViewController: _playerControlsVC, toContainer: _playerControlsContainer)
		add(childViewController: _subfilterSelectionVC, toContainer: _subfilterSelectionContainer)
		add(childViewController: _profileNavController, toContainer: _profileNavigationContainer)
		
		_profileNavController.viewControllers = [_profileViewController]
		_playerControlsVC.delegate = self
		
		let state = DefaultMainPlayerState(delegate: self)
		_currentState = state.transition(duration: 0)
		
		let filterSystem = _setupFilterSystem()
		_parentFilterSelectionVC.dataSource = filterSystem
		_subfilterSelectionVC.dataSource = filterSystem
		
		let nextAvailableSystem = _setupNextAvailableMediaSystem()
		_nextAvailableMediaVC.dataSource = nextAvailableSystem
		
		let currentTrackSystem = _setupCurrentTrackSystem()
		_largeCurrentTrackVC.dataSource = currentTrackSystem
		_compactCurrentTrackVC.dataSource = currentTrackSystem
		
		let ratingSystem = TrackRatingSystemController()
		
		let playerSystem = PlayerSystemController()
		
		_coordinationController = SystemCoordinationController(playerSystem: playerSystem,
		                                                       filterSystem: filterSystem,
		                                                       currentTrackSystem: currentTrackSystem,
		                                                       nextAvailableSystem: nextAvailableSystem,
		                                                       ratingSystem: ratingSystem)
		
		_subfilterSelectionVC.viewTappedClosure = {
			filterSystem.resetParentFilterSelection()
		}
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
	
	// MARK: - System Setup
	private func _setupFilterSystem() -> FilterSystemController {
		let filterSystem = FilterSystemController()
		filterSystem.didUpdateModel = _filterModelChanged
		filterSystem.didUpdateSelection = _filterSelectionChanged
		
		return filterSystem
	}
	
	private func _setupNextAvailableMediaSystem() -> NextAvailableMediaSystemController {
		let nextAvailableMediaSystem = NextAvailableMediaSystemController()
		nextAvailableMediaSystem.didUpdateModel = _nextAvailableMediaChanged
		nextAvailableMediaSystem.didUpdateSelection = _nextAvailableMediaSelectionChanged
		
		return nextAvailableMediaSystem
	}
	
	private func _setupCurrentTrackSystem() -> CurrentTrackSystemController {
		let currentTrackSystem = CurrentTrackSystemController()
		currentTrackSystem.didUpdateModel = _currentTrackModelChanged
		return currentTrackSystem
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		self.output = output
		
		_coordinationController?.handle(apiOutput: output)
		_playerControlsVC.update(withPlayerAPIOutput: output)
		
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
		_transition(toState: state, duration: 0.3)
	}
	
	private func _transition(toState state: MainPlayerState, duration: Double) {
		guard _currentState.dynamicType != state.dynamicType else { return }
		_currentState = state.transition(duration: duration)
	}
}

// MARK: - Async Image Downloading
extension MainPlayerViewController {
	internal func _imageFinishedLoading(image: UIImage?, url: NSURL?) {
		_backgroundImageView.image = image?.applyBlur(withRadius: 6.0, tintColor: nil, saturationDeltaFactor: 1.3)
	}
}

// MARK: - Filter System
extension MainPlayerViewController {
	private func _filterModelChanged(controller: FilterSystemController) {
		_parentFilterSelectionVC.syncData()
		_subfilterSelectionVC.syncData()
	}
	
	private func _filterSelectionChanged(controller: FilterSystemController) {
		var state: MainPlayerState = DefaultMainPlayerState(delegate: self)
		
		if controller.selectedParentFilter != nil {
			state = FilterSelectionMainPlayerState(delegate: self)
			_subfilterSelectionVC.syncUI()
		}
		
		_parentFilterSelectionVC.syncUI()
		_transition(toState: state, duration: 0.3)
	}
}

// MARK: - Next Available Media System
extension MainPlayerViewController {
	private func _nextAvailableMediaChanged(controller: NextAvailableMediaSystemController) {
		_nextAvailableMediaVC.syncData()
	}
	
	private func _nextAvailableMediaSelectionChanged(controller: NextAvailableMediaSystemController) {
		_nextAvailableMediaVC.syncUI()
	}
}

// MARK: - Current Track System
extension MainPlayerViewController {
	private func _currentTrackModelChanged(controller: CurrentTrackSystemController) {
		_largeCurrentTrackVC.syncUI()
		_compactCurrentTrackVC.syncUI()
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
		let selectedTrack = _coordinationController?.currentNextTrack?.mid
		let updates = PlayerAPIInputUpdates(abandonedRequests: nil, canPlay: true, filter: nil, select: selectedTrack, ratings: nil)
		playerAPIService?.requestNextTrack(withUpdates: updates, callback: _handlePlayerAPICallback)
	}
}