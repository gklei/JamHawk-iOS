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
	var playerSystemCurrentTrackMID: PlayerAPIMediaID? { get }
}

final class PlayerSystem: SystemController<PlayerAPIOutputMedia> {
	
	private var _media: PlayerAPIOutputMedia?
	
	private var _timeObserver: AnyObject?
	private let _player = AVPlayer()
	
	weak var delegate: PlayerSystemDelegate?
	var wantsToAdvance = false
	internal(set) var playerProgress: CGFloat = 0
	
	var currentMediaViewModel: PlayerAPIOutputMediaViewModel? {
		guard let media = _media else { return nil }
		return PlayerAPIOutputMediaViewModel(media: media)
	}
	
	override init() {
		super.init()
		_startObservingPlayer()
		_player.volume = 0.75
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
		return _player.muted || _player.volume == 0
	}
	
	var volume: Float {
		return _player.volume
	}
	
	func play() {
		_player.play()
		post(notification: .modelDidUpdate)
	}
	
	func pause() {
		_player.pause()
		post(notification: .modelDidUpdate)
	}
	
	func advanceTrack() {
		wantsToAdvance = true
		post(notification: .modelDidUpdate)
	}
	
	func update(playerVolume volume: Float, inProgress: Bool = false) {
		_player.volume = volume
		
		if !inProgress {
			post(notification: .modelDidUpdate)
		}
	}
	
	func register(event event: PlayerControlsEventType) {
		var notification: Notification?
		
		switch event {
		case .Play:
			_player.play()
			notification = .play
		case .Pause:
			_player.pause()
			notification = .pause
		case .NextTrack:
			wantsToAdvance = true
			notification = .skip
		}

		post(notification: .modelDidUpdate)
		
		guard let mid = delegate?.playerSystemCurrentTrackMID, note = notification else { return }
		post(notification: note, userInfo: [SystemControllerNotificationMIDKey : mid])
	}
}

extension PlayerSystem: Notifier {
	enum Notification: String {
		case modelDidUpdate
		case progressDidUpdate
		case play
		case pause
		case resume
		case skip
		case preloadedSkip
		case end
		case error
		case warning
	}
}