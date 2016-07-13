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

class MainPlayerViewController: UIViewController
{
	// MARK: - Outlets
	@IBOutlet private var _playbackControlsToolbar: UIToolbar!
	@IBOutlet private var _backgroundImageView: AsyncImageView!
	@IBOutlet private var _nextAvailableCollectionView: UICollectionView!
	
	@IBOutlet private var _playPauseItem: UIBarButtonItem!
	@IBOutlet private var _toggleMuteItem: UIBarButtonItem!
	
	// MARK: - Properties
	var output: PlayerAPIOutput?
	
	private var _playerProgressVC: PlayerProgressViewController?
	private var _nextAvailableMediaDS: NextAvailableMediaDataSource?
	
	private var _player = AVPlayer()
	private var _timeObserver: AnyObject?
	
	// MARK: - Overridden
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .Default
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let nib = UINib(nibName: NextAvailableMediaCell.xibName, bundle: nil)
		_nextAvailableCollectionView.registerNib(nib, forCellWithReuseIdentifier: NextAvailableMediaCell.reuseID)
		
		_nextAvailableMediaDS = NextAvailableMediaDataSource(collectionView: _nextAvailableCollectionView)
		_playbackControlsToolbar.update(backgroundColor: .whiteColor())
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.destinationViewController {
		case is PlayerProgressViewController:
			_playerProgressVC = segue.destinationViewController as? PlayerProgressViewController
			_playerProgressVC?.startObserving(player: _player)
		default: break
		}
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		self.output = output
		
		_playerProgressVC?.output = output
		_nextAvailableMediaDS?.output = output
		
		_updatePlayer(withOutput: output)
		_updateUI(withOutput: output)
		
		_nextAvailableCollectionView.reloadData()
	}
	
	// MARK: - Private
	private func _updatePlayer(withOutput output: PlayerAPIOutput) {
		guard let updatedItem = AVPlayerItem(output: output) else { return }
		
		_player.replaceCurrentItemWithPlayerItem(updatedItem)
		_player.seekToTime(kCMTimeZero)
		_player.play()
		
		_updateBarButtonItems()
	}
	
	private func _updateUI(withOutput output: PlayerAPIOutput) {
		let viewModel = PlayerAPIOutputViewModel(output: output)
		_backgroundImageView.imageURL = viewModel.posterURL
	}
	
	private func _updateBarButtonItems() {
		let playPauseImageName = _player.paused ? "play" : "pause"
		let toggleMuteImageName = _player.muted ? "mute" : "low_volume"
		
		_playPauseItem.image = UIImage(named: playPauseImageName)
		_toggleMuteItem.image = UIImage(named: toggleMuteImageName)
	}
	
	// MARK: - Actions
	@IBAction private func _userProfileButtonPressed() {
	}
	
	@IBAction private func _playPauseButtonPressed() {
		_togglePlayPause()
		_updateBarButtonItems()
	}
	
	@IBAction private func _nextTrackButtonPressed() {
		print("NEXT TRACK!")
	}
	
	@IBAction private func _toggleMuteButtonPressed() {
		_toggleMute()
		_updateBarButtonItems()
	}
}

// MARK: - AVPlayer Controls
extension MainPlayerViewController {
	private func _togglePlayPause() {
		if _player.paused {
			_player.play()
		} else {
			_player.pause()
		}
	}
	
	private func _toggleMute() {
		let volume: Float = _player.muted ? 1.0 : 0.0
		_player.volume = volume
	}
}