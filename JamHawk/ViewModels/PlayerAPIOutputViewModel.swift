//
//  PlayerAPIOutputViewModel.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/12/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import UIKit

struct PlayerAPIOutputMediaViewModel {
	let media: PlayerAPIOutputMedia
	
	var posterURL: NSURL? {
		guard let posterURLString = media.poster else { return nil }
		return NSURL(string: posterURLString)
	}
}

struct PlayerAPIOutputFilterViewModel: Equatable {
	let filter: PlayerAPIOutputFilter
	
	var filterName: String {
		return filter.label.uppercaseString
	}
	
	var subFilterNames: [String] {
		return filter.filterNames
	}
}

func ==(lhs: PlayerAPIOutputFilterViewModel, rhs: PlayerAPIOutputFilterViewModel) -> Bool {
	return lhs.filter == rhs.filter
}

struct PlayerAPIOutputMetadataViewModel {
	let metadata: PlayerAPIOutputMetadata
	
	var albumArtworkURL: NSURL? {
		guard let imageURLString = metadata.imageURL else { return nil }
		return NSURL(string: imageURLString)
	}
	
	var songTitle: String? {
		return metadata.title
	}
	
	var artistName: String? {
		return metadata.artist
	}
	
	var albumTitle: String? {
		return metadata.album
	}
	
	var artistAndSongTitle: String? {
		guard let artist = artistName else { return nil }
		guard let song = songTitle else { return nil }
		
		return "\(artist) – \(song)"
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

struct PlayerAPIOutputTrackRatingViewModel {
	let rating: PlayerAPIOutputTrackRating
}