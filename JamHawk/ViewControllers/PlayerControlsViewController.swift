//
//  PlayerControlsViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AVFoundation

enum PlayerControlsActionType {
	case ShowProfile, Play, Pause, NextTrack, Mute, Unmute
}

protocol PlayerControlsViewControllerDelegate: class {
	func playerControlsViewController(controller: PlayerControlsViewController, didExecuteAction action: PlayerControlsActionType)
}

final class PlayerControlsViewController: UIViewController, PlayerStoryboardInstantiable {
	
	// MARK: - Outlets
	@IBOutlet private var _playPauseItem: UIBarButtonItem!
	@IBOutlet private var _toggleMuteItem: UIBarButtonItem!
	@IBOutlet private var _profileItem: UIBarButtonItem!
	
	@IBOutlet private var _topPaddingView: UIView!
	@IBOutlet private var _bottomPaddingView: UIView!
	
	// MARK: - Properties
	weak var delegate: PlayerControlsViewControllerDelegate?
	
	private var _playerProgressVC: PlayerProgressViewController?
	private let _player = AVPlayer() // TODO: Take player out of here...
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		_profileItem.customView = UserProfileButtonView()
		
		let color = UIColor(white: 26.0 / 255.0, alpha: 1)
		_topPaddingView.backgroundColor = color
		_bottomPaddingView.backgroundColor = color
		
		_toggleMuteItem.tintColor = .whiteColor()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.destinationViewController {
		case is PlayerProgressViewController:
			_playerProgressVC = segue.destinationViewController as? PlayerProgressViewController
			_playerProgressVC?.startObserving(player: _player)
		default: break
		}
	}
	
	// MARK: - Private
	private func _updatePlayer(withOutput output: PlayerAPIOutput) {
		guard let updatedItem = AVPlayerItem(output: output) else { return }
		
		_player.replaceCurrentItemWithPlayerItem(updatedItem)
		_player.play()
		
		_updateBarButtonItems()
	}
	
	internal func _userProfileButtonPressed() {
		delegate?.playerControlsViewController(self, didExecuteAction: .ShowProfile)
	}
	
	@IBAction private func _playPauseButtonPressed() {
		_player.togglePlayPause()
		_updateBarButtonItems()
		
		// At this point if the player is paused, then the executed action was Pause
		let action: PlayerControlsActionType = _player.paused ? .Pause : .Play
		delegate?.playerControlsViewController(self, didExecuteAction: action)
	}
	
	@IBAction private func _nextTrackButtonPressed() {
		delegate?.playerControlsViewController(self, didExecuteAction: .NextTrack)
	}
	
	@IBAction private func _toggleMuteButtonPressed() {
		_player.toggleMute()
		_updateBarButtonItems()
		
		let action: PlayerControlsActionType = _player.muted ? .Mute : .Unmute
		delegate?.playerControlsViewController(self, didExecuteAction: action)
	}
	
	private func _updateBarButtonItems() {
		let playPauseImageName = _player.paused ? "play2" : "pause"
		let toggleMuteImageName = _player.muted ? "mute" : "low_volume2"
		
		_playPauseItem.image = UIImage(named: playPauseImageName)
		_toggleMuteItem.image = UIImage(named: toggleMuteImageName)
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		_playerProgressVC?.output = output
		_updatePlayer(withOutput: output)
	}
}
