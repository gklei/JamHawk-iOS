//
//  PlayerControlsViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

enum PlayerControlsEventType {
	case UserProfile, Play, Pause, NextTrack, Mute, Unmute
}

protocol PlayerDataSource: class {
	var paused: Bool { get }
	var muted: Bool { get }
	
	func update(playerVolume volume: Float)
	func register(event event: PlayerControlsEventType)
}

protocol PlayerControlsDelegate: class {
	func playerControlsProfileButtonPressed()
}

final class PlayerControlsViewController: UIViewController, PlayerStoryboardInstantiable {
	
	// MARK: - Outlets
	@IBOutlet private var _playPauseItem: UIBarButtonItem!
	@IBOutlet private var _toggleMuteItem: UIBarButtonItem!
	@IBOutlet private var _profileItem: UIBarButtonItem!
	
	@IBOutlet private var _topPaddingView: UIView!
	@IBOutlet private var _bottomPaddingView: UIView!
	
	// MARK: - Properties
	weak var dataSource: PlayerDataSource?
	weak var delegate: PlayerControlsDelegate?
	
	private var _playerProgressVC: PlayerProgressViewController?
	private let _volumeAdjustmentVC = VolumeAdjustmentViewController.create()
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let selector = #selector(PlayerControlsViewController._profileButtonPressed)
		_profileItem.customView = UserProfileButtonView(target: self, selector: selector)
		
		let color = UIColor(white: 0, alpha: 0.5)
		_topPaddingView.backgroundColor = color
		_bottomPaddingView.backgroundColor = color
		
		_toggleMuteItem.tintColor = .whiteColor()
		
		_volumeAdjustmentVC.delegate = self
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.destinationViewController {
		case is PlayerProgressViewController:
			_playerProgressVC = segue.destinationViewController as? PlayerProgressViewController
		default: break
		}
	}
	
	// MARK: - Private
	internal func _profileButtonPressed() {
		dataSource?.register(event: .UserProfile)
		delegate?.playerControlsProfileButtonPressed()
	}
	
	@IBAction private func _playPauseButtonPressed() {
		guard let dataSource = dataSource else { return }
		let event: PlayerControlsEventType = dataSource.paused ? .Play : .Pause
		dataSource.register(event: event)
	}
	
	@IBAction private func _nextTrackButtonPressed() {
		dataSource?.register(event: .NextTrack)
	}
	
	@IBAction private func _toggleMuteButtonPressed() {
		guard let dataSource = dataSource else { return }
		let event: PlayerControlsEventType = dataSource.muted ? .Unmute : .Mute
		dataSource.register(event: event)
	}
	
	@IBAction private func _volumeButtonPressed() {
		presentViewController(_volumeAdjustmentVC, animated: true, completion: nil)
	}
	
	private func _updateBarButtonItems() {
		guard let dataSource = dataSource else { return }
		
		let playPauseImageName = dataSource.paused ? "play2" : "pause"
		let toggleMuteImageName = dataSource.muted ? "mute" : "low_volume2"

		_playPauseItem.image = UIImage(named: playPauseImageName)
		_toggleMuteItem.image = UIImage(named: toggleMuteImageName)
	}
	
	// MARK: - Public
	func syncUI() {
		_updateBarButtonItems()
	}
	
	func updateProgress(progress: CGFloat) {
		_playerProgressVC?.updateProgress(progress)
	}
}

extension PlayerControlsViewController: VolumeAdjustmentDelegate {
	func volumeAdjustmentViewControllerDidUpdateVolume(volume: Float) {
		dataSource?.update(playerVolume: volume)
	}
}
