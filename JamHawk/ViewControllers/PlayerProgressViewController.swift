//
//  PlayerProgressViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/12/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AVFoundation

private let k60FramesPerSec = CMTimeMakeWithSeconds(1.0 / 60.0, Int32(NSEC_PER_SEC))

class PlayerProgressViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private var _trailingSpaceProgressConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	var output: PlayerAPIOutput?
	private var _timeObserver: AnyObject?
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		_resetProgressBar()
	}
	
	// MARK: - Public
	func startObserving(player player: AVPlayer) {
		_timeObserver = player.addPeriodicTimeObserverForInterval(k60FramesPerSec, queue: nil) {
			[weak self] time in
			self?._updateProgress(withCurrentTime: time)
		}
	}
	
	func stopObserving(player player: AVPlayer) {
		guard let timeObserver = _timeObserver else { return }
		player.removeTimeObserver(timeObserver)
	}
	
	// MARK: - Private
	private func _updateProgress(withCurrentTime time: CMTime) {
		guard let totalDuration = output?.track?.duration else { return }
		
		let seconds = CMTimeGetSeconds(time)
		let progress = CGFloat(seconds) / CGFloat(totalDuration)
		let trailingSpaceConstant = view.bounds.width * (1 - progress)
		
		_trailingSpaceProgressConstraint.constant = trailingSpaceConstant
	}
	
	private func _resetProgressBar() {
		self._trailingSpaceProgressConstraint.constant = self.view.bounds.width
	}
}
