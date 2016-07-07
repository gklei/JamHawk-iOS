//
//  PlayerAPIOutput.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

struct PlayerAPIOutput {
	let instance: PlayerAPIOutputInstance?
	let url: String?
	let filters: PlayerAPIOutputFilters?
	let media: PlayerAPIOutputMedia?
	let artist: PlayerAPIOutputArtist?
	let track: PlayerAPIOutputMetadata?
	let next: [PlayerAPIOutputMetadata]?
	let panels: AnyObject?
	let messages: PlayerAPIOutputMessage?
	let commands: [PlayerAPIOutputCommand]?
	let denied: Bool?
}