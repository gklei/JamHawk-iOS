//
//  PlayerAPIOutputViewModel.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/12/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

struct PlayerAPIOutputViewModel {
	let output: PlayerAPIOutput
	
	var posterURL: NSURL? {
		guard let poster = output.media?.poster else { return nil }
		return NSURL(string: poster)
	}
	
	var trackURL: NSURL? {
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
		return urlString != nil ? NSURL(string: urlString!) : nil
	}
}