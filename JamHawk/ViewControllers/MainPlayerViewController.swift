//
//  MainPlayerViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AsyncImageView
import IncipiaKit

extension Selector {
	static let filterUpdated = #selector(MainPlayerViewController._filterModelUpdated(_:))
	static let parentFilterSelectionUpdated = #selector(MainPlayerViewController._parentFilterSelectionUpdated(_:))
	static let subfilterSelectionUpdated = #selector(MainPlayerViewController._subfilterSelectionUpdated(_:))
	static let playerUpdated = #selector(MainPlayerViewController._playerModelUpdated(_:))
	static let playerProgressUpdated = #selector(MainPlayerViewController._playerProgressUpdated(_:))
	static let currentTrackUpdated = #selector(MainPlayerViewController._currentTrackUpdated(_:))
	static let nextAvailableMediaUpdated = #selector(MainPlayerViewController._nextAvailableMediaUpdated(_:))
	static let nextAvailableMediaSelectionUpdated = #selector(MainPlayerViewController._nextAvailableMediaSelectionUpdated(_:))
	static let currentTrackRatingUpdated = #selector(MainPlayerViewController._currentTrackRatingUpdated(_:))
}

final class MainPlayerViewController: UIViewController, PlayerStoryboardInstantiable {
	
	// MARK: - Outlets
	@IBOutlet private var _backgroundImageView: AsyncImageView!
	
	@IBOutlet internal var _parentFilterSelectionContainer: UIView!
	@IBOutlet internal var _largeCurrentTrackContainer: UIView!
	
	@IBOutlet internal var _compactCurrentTrackContainer: UIView!
	@IBOutlet internal var _nextAvailableMediaContainer: UIView!
	@IBOutlet internal var _longPressInfoContainer: UIView!
	
	@IBOutlet internal var _playerControlsContainer: UIView!
	@IBOutlet internal var _subfilterSelectionContainer: UIView!
	@IBOutlet internal var _profileNavigationContainer: UIView!
	@IBOutlet internal var _bottomContainerHeightConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	internal var _currentState: MainPlayerState!
	internal var _stateAfterNextModelUpdate: MainPlayerState?
	
	internal var _statusBarStyle = UIStatusBarStyle.LightContent
	
	internal let _parentFilterSelectionVC = ParentFilterSelectionViewController.create()
	internal var _subfilterSelectionVC = SubfilterSelectionViewController()
	
	internal let _compactCurrentTrackVC = CompactCurrentTrackViewController.create()
	internal let _largeCurrentTrackVC = LargeCurrentTrackViewController.create()
	
	internal let _nextAvailableMediaVC = NextAvailableMediaViewController.create()
	internal let _playerControlsVC = PlayerControlsViewController.create()
	
	internal let _profileViewController = ProfileViewController.instantiate(fromStoryboard: "Profile")
	internal let _profileNavController = ProfileNavigationController()
	
	internal let _longPressInfoController = LongPressTrackInfoController.create()
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		add(childViewController: _parentFilterSelectionVC, toContainer: _parentFilterSelectionContainer)
		add(childViewController: _largeCurrentTrackVC, toContainer: _largeCurrentTrackContainer)
		add(childViewController: _nextAvailableMediaVC, toContainer: _nextAvailableMediaContainer)
		add(childViewController: _compactCurrentTrackVC, toContainer: _compactCurrentTrackContainer)
		add(childViewController: _playerControlsVC, toContainer: _playerControlsContainer)
		add(childViewController: _subfilterSelectionVC, toContainer: _subfilterSelectionContainer)
		add(childViewController: _profileNavController, toContainer: _profileNavigationContainer)
		add(childViewController: _longPressInfoController, toContainer: _longPressInfoContainer)
		
		_backgroundImageView.layer.masksToBounds = true
		_profileNavController.viewControllers = [_profileViewController]
		_playerControlsVC.delegate = self
		_nextAvailableMediaVC.delegate = self
		
		// TODO: put the swipe recognizer on the container view -- the view controller should know nothing about it
		_compactCurrentTrackVC.swipeUpClosure = _compactCurrentTrackSwipedUp
		
		// A little hacky..
		transitionToDefaultState()
		
		FilterSystem.addObserver(self, selector: .filterUpdated, notification: .modelDidUpdate)
		FilterSystem.addObserver(self, selector: .parentFilterSelectionUpdated, notification: .parentFilterSelectionDidUpdate)
		FilterSystem.addObserver(self, selector: .subfilterSelectionUpdated, notification: .subfilterSelectionDidUpdate)
		
		PlayerSystem.addObserver(self, selector: .playerUpdated, notification: .modelDidUpdate)
		PlayerSystem.addObserver(self, selector: .playerProgressUpdated, notification: .progressDidUpdate)
		
		CurrentTrackSystem.addObserver(self, selector: .currentTrackUpdated, notification: .modelDidUpdate)
		TrackRatingSystem.addObserver(self, selector: .currentTrackRatingUpdated, notification: .modelDidUpdate)
		
		NextAvailableMediaSystem.addObserver(self, selector: .nextAvailableMediaUpdated, notification: .modelDidUpdate)
		NextAvailableMediaSystem.addObserver(self, selector: .nextAvailableMediaSelectionUpdated, notification: .selectionDidUpdate)
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
	
	private func _compactCurrentTrackSwipedUp() {
		if _currentState.isKindOfClass(FilterSelectionMainPlayerState) {
			_parentFilterSelectionVC.dataSource?.resetParentFilterSelection()
		} else {
			let state = DefaultMainPlayerState(delegate: self)
			_transition(toState: state, duration: 0.3)
		}
	}
	
	// MARK: - Public
	func setupSystems(withCoordinationController controller: SystemCoordinationController) {
		let _ = view // load the view
		
		_parentFilterSelectionVC.dataSource = controller.filterSystem
		_subfilterSelectionVC.dataSource = controller.filterSystem
		_subfilterSelectionVC.viewTappedClosure = controller.filterSystem.resetParentFilterSelection
		_playerControlsVC.dataSource = controller.playerSystem
		_largeCurrentTrackVC.dataSource = controller.currentTrackSystem
		_compactCurrentTrackVC.dataSource = controller.currentTrackSystem
		_nextAvailableMediaVC.dataSource = controller.nextAvailableSystem
		_largeCurrentTrackVC.trackRatingDataSource = controller.ratingSystem
		_compactCurrentTrackVC.trackRatingDataSource = controller.ratingSystem
	}
	
	func transitionToDefaultState() {
		_currentState = DefaultMainPlayerState(delegate: self)
		_transition(toState: _currentState, duration: 0)
	}
}

// MARK: - Async Image Downloading
extension MainPlayerViewController {
	internal func _imageFinishedLoading(image: UIImage?, url: NSURL?) {
		_backgroundImageView.image = image?.applyBlur(withRadius: 2.5, tintColor: nil, saturationDeltaFactor: 2)
	}
}

// MARK: - Systems
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
	internal func _nextAvailableMediaUpdated(notification: NSNotification) {
		_nextAvailableMediaVC.syncData()
	}
	
	internal func _nextAvailableMediaSelectionUpdated(notification: NSNotification) {
		_nextAvailableMediaVC.syncUI()
	}
	
	// MARK: - Current Track System
	internal func _currentTrackUpdated(notification: NSNotification) {
		_largeCurrentTrackVC.syncUI()
		_compactCurrentTrackVC.syncUI()
	}
	
	// MARK: - Current Track Rating System
	internal func _currentTrackRatingUpdated(notification: NSNotification) {
		_largeCurrentTrackVC.syncUI()
		_compactCurrentTrackVC.syncUI()
	}
}

extension MainPlayerViewController: NextAvailableMediaViewControllerDelegate {

	func nextAvailableMediaLongPressDidStart(viewModel: PlayerAPIOutputMetadataViewModel, targetRect: CGRect, controller: NextAvailableMediaViewController) {
		let thumbnailRect = controller.view.convertRect(targetRect, toView: nil)
		_longPressInfoController.update(withViewModel: viewModel, thumbnailRect: thumbnailRect)
		
		let state = ShowTrackDetailsState(delegate: self)
		_transition(toState: state, duration: 0.5)
	}
	
	func nextAvailableMediaLongPressDidEnd(viewModel: PlayerAPIOutputMetadataViewModel, controller: NextAvailableMediaViewController) {
		let state = DefaultMainPlayerState(delegate: self)
		_transition(toState: state, duration: 0.3)
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
}