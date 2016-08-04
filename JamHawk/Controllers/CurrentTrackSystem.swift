//
//  CurrentTrackSystem.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

final class CurrentTrackSystem: SystemController<PlayerAPIOutputMetadata> {
	private var _track: PlayerAPIOutputMetadata?
	
	override func update(withModel model: PlayerAPIOutputMetadata?) {
		guard let model = model else { return }
		_track = model
		
		post(notification: .modelDidUpdate)
	}
}

extension CurrentTrackSystem: CurrentTrackDataSource {
	var currentTrackViewModel: PlayerAPIOutputMetadataViewModel? {
		guard let track = _track else { return nil }
		return PlayerAPIOutputMetadataViewModel(metadata: track)
	}
}

extension CurrentTrackSystem: Notifier {
	enum Notification: String {
		case modelDidUpdate
	}
}