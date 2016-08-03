//
//  PlayerSystem.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import AVFoundation

// TODO:
// Pull the event queue/system out of here!

private let k60FramesPerSec = CMTimeMakeWithSeconds(1.0 / 60.0, Int32(NSEC_PER_SEC))

protocol PlayerSystemDelegate: class {
	func playerSystemNextTrackRequested(system: PlayerSystem)
}

final class PlayerSystem: SystemController<PlayerAPIOutputMedia> {
	
	private var _media: PlayerAPIOutputMedia?
	
	private var _timeObserver: AnyObject?
	private let _player = AVPlayer()
	
	weak var delegate: PlayerSystemDelegate?
	internal(set) var playerProgress: CGFloat = 0
	
	var currentMediaViewModel: PlayerAPIOutputMediaViewModel? {
		guard let media = _media else { return nil }
		return PlayerAPIOutputMediaViewModel(media: media)
	}
	
	override init() {
		super.init()
		_startObservingPlayer()
	}
	
	// MARK: - Private
	private func _startObservingPlayer() {
		_timeObserver = _player.addPeriodicTimeObserverForInterval(k60FramesPerSec, queue: nil) {
			[weak self] time in
			
			let totalDuration = 180
			let seconds = CMTimeGetSeconds(time)
			self?.playerProgress = CGFloat(seconds) / CGFloat(totalDuration)
			self?.post(notification: .progressDidUpdate)
		}
	}
	
	private func _stopObserving(player player: AVPlayer) {
		guard let timeObserver = _timeObserver else { return }
		player.removeTimeObserver(timeObserver)
	}
	
	override func update(withModel model: PlayerAPIOutputMedia?) {
		guard let model = model, updatedItem = AVPlayerItem(media: model) else { return }
		
		_media = model
		_player.replaceCurrentItemWithPlayerItem(updatedItem)
		_player.play()
		
		post(notification: .modelDidUpdate)
	}
}

extension PlayerSystem: PlayerDataSource {
	var paused: Bool {
		return _player.paused
	}
	
	var muted: Bool {
		return _player.muted
	}
	
	func register(event event: PlayerControlsEventType) {
		var didUpdate = true
		switch event {
		case .Play: _player.play()
		case .Pause: _player.pause()
		case .Mute: _player.muted = true
		case .Unmute: _player.muted = false
		case .NextTrack: delegate?.playerSystemNextTrackRequested(self)
		case .UserProfile: didUpdate = false
		}
		
		if didUpdate {
			post(notification: .modelDidUpdate)
		}
	}
}

extension PlayerSystem: Notifier {
	enum Notification: String {
		case modelDidUpdate
		case progressDidUpdate
	}
}