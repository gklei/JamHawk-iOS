//
//  AVPlayer+Extensions.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/12/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import AVFoundation

extension AVPlayerItem {
	convenience init?(output: PlayerAPIOutput) {
		var urlString: String?
		if let mp3 = output.media?.mp3 {
			urlString = mp3
		}
		else if let m4v = output.media?.m4v {
			urlString = m4v
		}
		else if let m4a = output.media?.m4a {
			urlString = m4a
		}
		
		guard let string = urlString else { return nil }
		guard let url = NSURL(string: string) else { return nil }
		self.init(URL: url)
	}
	
	convenience init?(media: PlayerAPIOutputMedia) {
		var urlString: String?
		if let mp3 = media.mp3 {
			urlString = mp3
		}
		else if let m4v = media.m4v {
			urlString = m4v
		}
		else if let m4a = media.m4a {
			urlString = m4a
		}
		
		guard let string = urlString else { return nil }
		guard let url = NSURL(string: string) else { return nil }
		self.init(URL: url)
	}
}

extension AVPlayer {
	var paused: Bool {
		return rate == 0
	}
	
	var muted: Bool {
		return volume == 0
	}
	
	func togglePlayPause() {
		if paused {
			play()
		} else {
			pause()
		}
	}
	
	func toggleMute() {
		volume = muted ? 1.0 : 0.0
	}
}
