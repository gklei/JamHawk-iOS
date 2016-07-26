//
//  CurrentTrackSystemController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

final class CurrentTrackSystemController: SystemController<PlayerAPIOutputMetadata> {
	private var _track: PlayerAPIOutputMetadata?
	
	var didUpdateModel: (controller: CurrentTrackSystemController) -> Void = {_ in}
	var didUpdateSelection: (controller: CurrentTrackSystemController) -> Void = {_ in}
	
	var currentTrackViewModel: PlayerAPIOutputMetadataViewModel? {
		guard let track = _track else { return nil }
		return PlayerAPIOutputMetadataViewModel(metadata: track)
	}
	
	override func update(withModel model: PlayerAPIOutputMetadata?) {
		guard let model = model else { return }
		_track = model
		
		didUpdateModel(controller: self)
	}
}