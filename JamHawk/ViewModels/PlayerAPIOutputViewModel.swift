//
//  PlayerAPIOutputViewModel.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/12/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

struct PlayerAPIOutputMediaViewModel {
	let media: PlayerAPIOutputMedia
	
	var posterURL: NSURL? {
		guard let posterURLString = media.poster else { return nil }
		return NSURL(string: posterURLString)
	}
}

struct PlayerAPIOutputFilterViewModel {
	let filter: PlayerAPIOutputFilter
	
	var filterName: String {
		return filter.label
	}
	
	var subFilterNames: [String] {
		return filter.filterNames
	}
}

struct PlayerAPIOutputMetadataViewModel {
	let metatdata: PlayerAPIOutputMetadata
	
	var albumArtworkURL: NSURL? {
		guard let imageURLString = metatdata.imageURL else { return nil }
		return NSURL(string: imageURLString)
	}
	
	var songTitle: String? {
		return metatdata.title
	}
	
	var artistName: String? {
		return metatdata.artist
	}
	
	var albumTitle: String? {
		return metatdata.album
	}
}

struct PlayerAPIOutputArtistViewModel {
	let artist: PlayerAPIOutputArtist
	
	var name: String? {
		return artist.name
	}
	
	var text: String? {
		return artist.text
	}
}