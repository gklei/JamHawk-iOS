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
	func playerControlsViewController(controller: PlayerControlsViewController, executedAction action: PlayerControlsActionType)
}

class PlayerControlsViewController: UIViewController {
	// MARK: - Properties
	weak var delegate: PlayerControlsViewControllerDelegate?
	
	private var _playerProgressVC: PlayerProgressViewController?
	private let _player = AVPlayer()
	
	@IBOutlet private var _playPauseItem: UIBarButtonItem!
	@IBOutlet private var _toggleMuteItem: UIBarButtonItem!
	@IBOutlet private var _profileItem: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		_setupProfileItem()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.destinationViewController {
		case is PlayerProgressViewController:
			_playerProgressVC = segue.destinationViewController as? PlayerProgressViewController
			_playerProgressVC?.startObserving(player: _player)
		default: break
		}
	}
	
	private func _setupProfileItem() {
		let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
		profileButton.setImage(UIImage(named: "headphones"), forState: .Normal)
		profileButton.backgroundColor = UIColor.orangeColor()
		profileButton.tintColor = UIColor.whiteColor()
		profileButton.layer.cornerRadius = 12.0
		profileButton.layer.borderColor = UIColor.jmhLightGrayColor().CGColor
		profileButton.layer.borderWidth = 2
		
		let selector: Selector = #selector(PlayerControlsViewController._userProfileButtonPressed)
		profileButton.addTarget(self, action: selector, forControlEvents: .TouchUpInside)
		
		_profileItem.customView = profileButton
	}
	
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		_playerProgressVC?.output = output
		_updatePlayer(withOutput: output)
	}
	
	private func _updatePlayer(withOutput output: PlayerAPIOutput) {
		guard let updatedItem = AVPlayerItem(output: output) else { return }
		
		_player.replaceCurrentItemWithPlayerItem(updatedItem)
		_player.play()
		
		_updateBarButtonItems()
	}
	
	internal func _userProfileButtonPressed() {
		delegate?.playerControlsViewController(self, executedAction: .ShowProfile)
	}
	
	@IBAction private func _playPauseButtonPressed() {
		_player.togglePlayPause()
		_updateBarButtonItems()
		
		// At this point if the player is paused, then the executed action was Pause
		let action: PlayerControlsActionType = _player.paused ? .Pause : .Play
		delegate?.playerControlsViewController(self, executedAction: action)
	}
	
	@IBAction private func _nextTrackButtonPressed() {
		delegate?.playerControlsViewController(self, executedAction: .NextTrack)
	}
	
	@IBAction private func _toggleMuteButtonPressed() {
		_player.toggleMute()
		_updateBarButtonItems()
		
		let action: PlayerControlsActionType = _player.muted ? .Mute : .Unmute
		delegate?.playerControlsViewController(self, executedAction: action)
	}
	
	private func _updateBarButtonItems() {
		let playPauseImageName = _player.paused ? "play" : "pause"
		let toggleMuteImageName = _player.muted ? "mute" : "low_volume"
		
		_playPauseItem.image = UIImage(named: playPauseImageName)
		_toggleMuteItem.image = UIImage(named: toggleMuteImageName)
	}
}
