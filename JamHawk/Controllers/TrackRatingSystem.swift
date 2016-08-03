//
//  TrackRatingSystem.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

final class TrackRatingSystem: SystemController<PlayerAPIOutputMetadata> {
	private var _track: PlayerAPIOutputMetadata?
	
	var currentTrackViewModel: PlayerAPIOutputMetadataViewModel? {
		guard let track = _track else { return nil }
		return PlayerAPIOutputMetadataViewModel(metadata: track)
	}
	
	override func update(withModel model: PlayerAPIOutputMetadata?) {
		guard let model = model else { return }
		_track = model
		
		post(notification: .modelDidUpdate)
	}
}

extension TrackRatingSystem: TrackRatingDataSource {
	var ratingOptions: [PlayerAPIOutputTrackRating] {
		return [.Negative, .Positive]
	}
	
	var currentTrackRating: PlayerAPIOutputTrackRating? {
		guard let track = _track else { return nil }
		return track.rating
	}
	
	func rateCurrentTrack(rating: PlayerAPIOutputTrackRating) {
		guard let current = _track else { return }
		_track = current.copy(withRating: rating)
		
		post(notification: .modelDidUpdate)
	}
}

extension TrackRatingSystem: Notifier {
	enum Notification: String {
		case modelDidUpdate
	}
}