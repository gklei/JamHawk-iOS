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

private let kDefaultTransitionDuration: Double = 0.2

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
	
	// MARK: - Public Properties
	var showCoachingTips: Bool = false
	let coachingTipsController = CoachingTipsViewController.instantiate(fromStoryboard: "SignIn")
	
	// MARK: - Internal Properties
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
		
		_currentState = DefaultMainPlayerState(delegate: self)
		_transition(toState: _currentState, duration: 0)
		
		FilterSystem.addObserver(self, selector: .filterUpdated, notification: .modelDidUpdate)
		FilterSystem.addObserver(self, selector: .parentFilterSelectionUpdated, notification: .parentFilterSelectionDidUpdate)
		FilterSystem.addObserver(self, selector: .subfilterSelectionUpdated, notification: .subfilterSelectionDidUpdate)
		
		PlayerSystem.addObserver(self, selector: .playerUpdated, notification: .modelDidUpdate)
		PlayerSystem.addObserver(self, selector: .playerProgressUpdated, notification: .progressDidUpdate)
		
		CurrentTrackSystem.addObserver(self, selector: .currentTrackUpdated, notification: .modelDidUpdate)
		TrackRatingSystem.addObserver(self, selector: .currentTrackRatingUpdated, notification: .modelDidUpdate)
		
		NextAvailableMediaSystem.addObserver(self, selector: .nextAvailableMediaUpdated, notification: .modelDidUpdate)
		NextAvailableMediaSystem.addObserver(self, selector: .nextAvailableMediaSelectionUpdated, notification: .selectionDidUpdate)
		
		coachingTipsController.delegate = self
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
		removeRightBarItem()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if showCoachingTips {
			let navController = JamHawkNavigationController(rootViewController: coachingTipsController)
			navController.modalPresentationStyle = .OverCurrentContext
			navController.modalTransitionStyle = .CrossDissolve
			
			presentViewController(navController, animated: true, completion: nil)
		}
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return _statusBarStyle
	}
	
	// MARK: - Private
	private func _updateUI(withViewModel vm: PlayerAPIOutputMetadataViewModel) {
		let loadImageSelector = #selector(MainPlayerViewController._imageFinishedLoading(_:url:))
		let loader = AsyncImageLoader.sharedLoader()
		loader.cancelLoadingImagesForTarget(_backgroundImageView)
		loader.loadImageWithURL(vm.albumArtworkURL, target: self, action: loadImageSelector)
	}
	
	private func _transition(toState state: MainPlayerState, duration: Double) {
		_currentState = state.transition(duration: duration)
	}
	
	private func _compactCurrentTrackSwipedUp() {
		if _currentState.isKindOfClass(FilterSelectionMainPlayerState) {
			_parentFilterSelectionVC.dataSource?.resetParentFilterSelection()
		} else {
			let state = DefaultMainPlayerState(delegate: self)
			_transition(toState: state, duration: kDefaultTransitionDuration)
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
		_transition(toState: state, duration: kDefaultTransitionDuration)
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
		
		guard let system = notification.object as? CurrentTrackSystem else { return }
		guard let vm = system.currentTrackViewModel else { return }
		
		let sharedLoader = AsyncImageLoader.sharedLoader()
		if let image = sharedLoader.cache?.objectForKey(vm.albumArtworkURL!) as? UIImage {
			_backgroundImageView.image = image.applyBlur(withRadius: 2.5, tintColor: nil, saturationDeltaFactor: 2)
		} else {
			_updateUI(withViewModel: vm)
		}
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
		_transition(toState: state, duration: 0.4)
	}
	
	func nextAvailableMediaLongPressDidEnd(viewModel: PlayerAPIOutputMetadataViewModel, controller: NextAvailableMediaViewController) {
		let state = DefaultMainPlayerState(delegate: self)
		_transition(toState: state, duration: kDefaultTransitionDuration)
	}
}

extension MainPlayerViewController: PlayerControlsDelegate {
	
	func playerControlsProfileButtonPressed() {
		if _currentState.isKindOfClass(FilterSelectionMainPlayerState) {
			_stateAfterNextModelUpdate = ShowProfileState(delegate: self)
			_parentFilterSelectionVC.dataSource?.resetParentFilterSelection()
		} else {
			let state = ShowProfileState(delegate: self)
			_transition(toState: state, duration: kDefaultTransitionDuration)
		}
	}
}

extension MainPlayerViewController: CoachingTipsViewControllerDelegate {
	
	func focusRect(forState state: CoachingTipsState) -> CGRect {
		switch state {
		case .Welcome: return CGRect.zero
		case .NextSong: return _nextAvailableMediaContainer.frame
		case .Filters: return _parentFilterSelectionContainer.frame
		}
	}
	
	func mainTitleText(forState state: CoachingTipsState) -> String {
		return state.mainTitleText
	}
	
	func subtitleText(forState state: CoachingTipsState) -> String {
		return state.subtitleText
	}
	
	func buttonTitleText(forState state: CoachingTipsState) -> String {
		return state.buttonTitleText
	}
	
	func icon(forState state: CoachingTipsState) -> UIImage? {
		return state.iconImage
	}
	
	func nextButtonPressed(forCurrentState state: CoachingTipsState) {
		switch state {
		case .Welcome: coachingTipsController.currentState = .NextSong
		case .NextSong: coachingTipsController.currentState = .Filters
		case .Filters:
			navigationController?.setNavigationBarHidden(true, animated: true)
			coachingTipsController.navigationController?.dismissViewControllerAnimated(true, completion: nil)
			JamhawkStorage.userHasSeenCoachingTips = true
		}
	}
	
	func skipAllButtonPressed(forCurrentState state: CoachingTipsState) {
		navigationController?.setNavigationBarHidden(true, animated: true)
		coachingTipsController.navigationController?.dismissViewControllerAnimated(true, completion: nil)
		JamhawkStorage.userHasSeenCoachingTips = true
	}
}