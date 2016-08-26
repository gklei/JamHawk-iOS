//
//  NextAvailableMediaSystem.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

final class NextAvailableMediaSystem: SystemController<[PlayerAPIOutputMetadata]> {
	private var _next: [PlayerAPIOutputMetadata]?
	
	var currentNextTrackSelection: PlayerAPIOutputMetadata?
	
	override func update(withModel model: [PlayerAPIOutputMetadata]?) {
		guard let model = model else { return }
		_next = model
		
		post(notification: .modelDidUpdate)
	}
}

extension NextAvailableMediaSystem: NextAvailableMediaSelectionDataSource {
	var nextAvailableMediaViewModels: [PlayerAPIOutputMetadataViewModel] {
		guard let next = _next else { return [] }
		return next.flatMap({ PlayerAPIOutputMetadataViewModel(metadata: $0) })
	}
	
	var selectedMediaIndex: Int? {
		guard let next = _next else { return nil }
		guard let track = currentNextTrackSelection else { return nil }
		return next.indexOf(track)
	}
	
	func viewModel(atIndex index: Int) -> PlayerAPIOutputMetadataViewModel? {
		let vms = nextAvailableMediaViewModels
		guard index < vms.count else { return nil }
		return vms[index]
	}
	
	func selectMedia(atIndex index: Int) {
		guard let next = _next where next.count > index else { return }
		
		let selection = next[index]
		currentNextTrackSelection = selection
		
		post(notification: .selectionDidUpdate)
	}
}

extension NextAvailableMediaSystem: Notifier {
	enum Notification: String {
		case modelDidUpdate
		case selectionDidUpdate
	}
}