//
//  PlayerAPIOutput+Extensions.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/10/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

extension PlayerAPIOutputMedia {
	var trackURL: NSURL? {
		var urlString: String?
		if let mp3 = mp3 {
			urlString = mp3
		}
		else if let m4v = m4v {
			urlString = m4v
		}
		else if let m4a = m4a {
			urlString = m4a
		}
		return urlString != nil ? NSURL(string: urlString!) : nil
	}
	
	var posterURL: NSURL? {
		guard let poster = poster else { return nil }
		return NSURL(string: poster)
	}
}