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

extension Selector {
	static let filterModelUpdated = #selector(MainPlayerViewController._filterModelUpdated(_:))
	static let parentFilterSelectionUpdated = #selector(MainPlayerViewController._parentFilterSelectionUpdated(_:))
	static let subfilterSelectionUpdated = #selector(MainPlayerViewController._subfilterSelectionUpdated(_:))
	
	static let playerModelUpdated = #selector(MainPlayerViewController._playerModelUpdated(_:))
	static let playerProgressUpdated = #selector(MainPlayerViewController._playerProgressUpdated(_:))
}

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
		
		FilterSystem.addObserver(self, selector: .filterModelUpdated, notification: .didUpdateModel)
		FilterSystem.addObserver(self, selector: .parentFilterSelectionUpdated, notification: .didUpdateParentFilterSelection)
		FilterSystem.addObserver(self, selector: .subfilterSelectionUpdated, notification: .didUpdateSubfilterSelection)
		
		PlayerSystem.addObserver(self, selector: .playerModelUpdated, notification: .didUpdateModel)
		PlayerSystem.addObserver(self, selector: .playerProgressUpdated, notification: .didUpdateProgress)
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
		
		_setupNextAvailableMediaSystem(withController: controller)
		_setupCurrentTrackSystem(withController: controller)
		_setupRatingSystem(withController: controller)
		
		_parentFilterSelectionVC.dataSource = controller.filterSystem
		_subfilterSelectionVC.dataSource = controller.filterSystem
		_subfilterSelectionVC.viewTappedClosure = controller.filterSystem.resetParentFilterSelection
		
		_playerControlsVC.dataSource = controller.playerSystem
	}
}

// MARK: - Async Image Downloading
extension MainPlayerViewController {
	internal func _imageFinishedLoading(image: UIImage?, url: NSURL?) {
		_backgroundImageView.image = image?.applyBlur(withRadius: 2.5, tintColor: nil, saturationDeltaFactor: 2)
	}
}

// MARK: - System Controllers
extension MainPlayerViewController {
	
	// MARK: - Player System
	internal func _playerModelUpdated(notification: NSNotification) {
		guard let system = notification.object as? PlayerSystem else { return }
		guard let vm = system.currentMediaViewModel else { return }
		
		_updateUI(withCurrentTrackViewModel: vm)
		_playerControlsVC.syncUI()
	}
	
	internal func _playerProgressUpdated(notification: NSNotification) {
		guard let system = notification.object as? PlayerSystem else { return }
		_playerControlsVC.updateProgress(system.playerProgress)
	}
	
	// MARK: - Filter System
	internal func _filterModelUpdated(notification: NSNotification) {
		_parentFilterSelectionVC.syncData()
		_subfilterSelectionVC.syncData()
	}
	
	internal func _parentFilterSelectionUpdated(notification: NSNotification) {
		guard let system = notification.object as? FilterSystem else { return }
		
		var state: MainPlayerState = DefaultMainPlayerState(delegate: self)
		if system.selectedParentFilter != nil {
			state = FilterSelectionMainPlayerState(delegate: self)
		}
		
		_subfilterSelectionVC.syncData()
		_parentFilterSelectionVC.syncUI()
		_transition(toState: state, duration: 0.3)
	}
	
	internal func _subfilterSelectionUpdated(notification: NSNotification) {
		_parentFilterSelectionVC.syncUI()
	}
	
	// MARK: - Next Available System
	private func _nextAvailableMediaChanged(controller: NextAvailableMediaSystem) {
		_nextAvailableMediaVC.syncData()
	}
	
	private func _nextAvailableMediaSelectionChanged(controller: NextAvailableMediaSystem) {
		_nextAvailableMediaVC.syncUI()
	}
	
	// MARK: - Current Track System
	private func _currentTrackModelChanged(controller: CurrentTrackSystem) {
		_largeCurrentTrackVC.syncUI()
		_compactCurrentTrackVC.syncUI()
	}
	
	// MARK: - Current Track Rating System
	private func _currentTrackRatingChanged(controller: TrackRatingSystem) {
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