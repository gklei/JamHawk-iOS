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
	internal var _currentState: MainPlayerState!
	internal var _stateAfterNextModelUpdate: MainPlayerState?
	
	internal var _statusBarStyle = UIStatusBarStyle.LightContent
	
	private let _parentFilterSelectionVC = ParentFilterSelectionViewController.create()
	private var _subfilterSelectionVC = SubfilterSelectionViewController()
	
	private let _compactCurrentTrackVC = CompactCurrentTrackViewController.create()
	internal let _largeCurrentTrackVC = LargeCurrentTrackViewController.create()
	
	private let _nextAvailableMediaVC = NextAvailableMediaViewController.create()
	private let _playerControlsVC = PlayerControlsViewController.create()
	
	private let _profileViewController = ProfileViewController.instantiate(fromStoryboard: "Profile")
	private let _profileNavController = ProfileNavigationController()
	
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
		
		// TODO: put the swipe recognizer on the container view -- the view controller should know nothing about it
		_compactCurrentTrackVC.swipeUpClosure = _compactCurrentTrackSwipedUp
		
		// A little hacky..
		_currentState = DefaultMainPlayerState(delegate: self)
		_transition(toState: _currentState, duration: 0)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
		removeRightBarItem()
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return _statusBarStyle
	}
	
	// MARK: - System Setup
	private func _setupFilterSystem(withController controller: SystemCoordinationController) {
		controller.filterSystem.didUpdateModel = _filterModelChanged
		controller.filterSystem.didUpdateParentFilterSelection = _filterSelectionChanged
		controller.filterSystem.didUpdateSubfilterFilterSelection = _subfilterSelectionChanged
		_parentFilterSelectionVC.dataSource = controller.filterSystem
		_subfilterSelectionVC.dataSource = controller.filterSystem
		
		_subfilterSelectionVC.viewTappedClosure = {
			controller.filterSystem.resetParentFilterSelection()
		}
	}
	
	private func _setupNextAvailableMediaSystem(withController controller: SystemCoordinationController) {
		controller.nextAvailableSystem.didUpdateModel = _nextAvailableMediaChanged
		controller.nextAvailableSystem.didUpdateSelection = _nextAvailableMediaSelectionChanged
		_nextAvailableMediaVC.dataSource = controller.nextAvailableSystem
	}
	
	private func _setupCurrentTrackSystem(withController controller: SystemCoordinationController)  {
		controller.currentTrackSystem.didUpdateModel = _currentTrackModelChanged
		_largeCurrentTrackVC.dataSource = controller.currentTrackSystem
		_compactCurrentTrackVC.dataSource = controller.currentTrackSystem
	}
	
	private func _setupRatingSystem(withController controller: SystemCoordinationController) {
		controller.ratingSystem.didUpdateModel = _currentTrackRatingChanged
		_largeCurrentTrackVC.trackRatingDataSource = controller.ratingSystem
		_compactCurrentTrackVC.trackRatingDataSource = controller.ratingSystem
	}
	
	private func _setupPlayerSystem(withController controller: SystemCoordinationController) {
		controller.playerSystem.didUpdateModel = _playerModelChanged
		controller.playerSystem.playerProgressClosure = _playerProgressUpdated
		_playerControlsVC.dataSource = controller.playerSystem
	}
	
	// MARK: - Private
	private func _updateUI(withCurrentTrackViewModel vm: PlayerAPIOutputMediaViewModel) {
		let loadImageSelector = #selector(MainPlayerViewController._imageFinishedLoading(_:url:))
		let loader = AsyncImageLoader.sharedLoader()
		loader.cancelLoadingImagesForTarget(_backgroundImageView)
		loader.loadImageWithURL(vm.posterURL, target: self, action: loadImageSelector)
	}
	
	private func _transition(toState state: MainPlayerState, duration: Double) {
		guard _currentState.dynamicType != state.dynamicType else { return }
		_currentState = state.transition(duration: duration)
	}
	
	// MARK: - Public
	func setupSystems(withCoordinationController controller: SystemCoordinationController) {
		let _ = view // load the view
		
		_setupFilterSystem(withController: controller)
		_setupNextAvailableMediaSystem(withController: controller)
		_setupCurrentTrackSystem(withController: controller)
		_setupRatingSystem(withController: controller)
		_setupPlayerSystem(withController: controller)
	}
}

// MARK: - Async Image Downloading
extension MainPlayerViewController {
	internal func _imageFinishedLoading(image: UIImage?, url: NSURL?) {
		_backgroundImageView.image = image?.applyBlur(withRadius: 3.5, tintColor: nil, saturationDeltaFactor: 1.2)
	}
}

// MARK: - System Controllers
extension MainPlayerViewController {
	
	// MARK: - Player System
	private func _playerModelChanged(controller: PlayerSystemController) {
		_playerControlsVC.syncUI()
		
		guard let viewModel = controller.currentMediaViewModel else { return }
		_updateUI(withCurrentTrackViewModel: viewModel)
	}
	
	private func _playerProgressUpdated(progress: CGFloat) {
		_playerControlsVC.updateProgress(progress)
	}
	
	// MARK: - Filter System
	private func _filterModelChanged(controller: FilterSystemController) {
		_parentFilterSelectionVC.syncData()
		_subfilterSelectionVC.syncData()
	}
	
	private func _filterSelectionChanged(controller: FilterSystemController) {
		var state: MainPlayerState = DefaultMainPlayerState(delegate: self)
		if controller.selectedParentFilter != nil {
			state = FilterSelectionMainPlayerState(delegate: self)
		}
		
		_subfilterSelectionVC.syncData()
		_parentFilterSelectionVC.syncUI()
		_transition(toState: state, duration: 0.3)
	}
	
	private func _subfilterSelectionChanged(controller: FilterSystemController) {
		_parentFilterSelectionVC.syncUI()
	}
	
	// MARK: - Next Available System
	private func _nextAvailableMediaChanged(controller: NextAvailableMediaSystemController) {
		_nextAvailableMediaVC.syncData()
	}
	
	private func _nextAvailableMediaSelectionChanged(controller: NextAvailableMediaSystemController) {
		_nextAvailableMediaVC.syncUI()
	}
	
	// MARK: - Current Track System
	private func _currentTrackModelChanged(controller: CurrentTrackSystemController) {
		_largeCurrentTrackVC.syncUI()
		_compactCurrentTrackVC.syncUI()
	}
	
	// MARK: - Current Track Rating System
	private func _currentTrackRatingChanged(controller: TrackRatingSystemController) {
		_largeCurrentTrackVC.syncUI()
		_compactCurrentTrackVC.syncUI()
	}
}

extension MainPlayerViewController: PlayerControlsDelegate {
	func playerControlsProfileButtonPressed() {
		if _currentState.isKindOfClass(FilterSelectionMainPlayerState) {
			_stateAfterNextModelUpdate = ShowProfileState(delegate: self)
			_parentFilterSelectionVC.dataSource?.resetParentFilterSelection()
		} else {
			let state = ShowProfileState(delegate: self)
			_transition(toState: state, duration: 0.3)
		}
	}
	
	private func _compactCurrentTrackSwipedUp() {
		if _currentState.isKindOfClass(FilterSelectionMainPlayerState) {
			_parentFilterSelectionVC.dataSource?.resetParentFilterSelection()
		} else {
			let state = DefaultMainPlayerState(delegate: self)
			_transition(toState: state, duration: 0.3)
		}
	}
}