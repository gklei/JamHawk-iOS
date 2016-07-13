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
}