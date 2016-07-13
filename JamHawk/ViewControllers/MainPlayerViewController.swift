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
	}
	
	private func _updateUI(withOutput output: PlayerAPIOutput) {
		let viewModel = PlayerAPIOutputViewModel(output: output)
		_backgroundImageView.imageURL = viewModel.posterURL
	}
}