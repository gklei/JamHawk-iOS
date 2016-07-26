//
//  NextAvailableMediaSystemController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

final class NextAvailableMediaSystemController: SystemController<[PlayerAPIOutputMetadata]> {
	private var _next: [PlayerAPIOutputMetadata]?
	var needNext: Bool = false
	
	var didUpdateModel: (controller: NextAvailableMediaSystemController) -> Void = {_ in}
	var didUpdateSelection: (controller: NextAvailableMediaSystemController) -> Void = {_ in}
	
	var currentNextTrackSelection: PlayerAPIOutputMetadata?
	
	var nextAvailableMediaViewModels: [PlayerAPIOutputMetadataViewModel] {
		guard let next = _next else { return [] }
		return next.flatMap({ PlayerAPIOutputMetadataViewModel(metadata: $0) })
	}
	
	override func update(withModel model: [PlayerAPIOutputMetadata]?) {
		guard let model = model else { return }
		_next = model
		
		didUpdateModel(controller: self)
	}
	
	func selectTrack(atIndex index: Int) {
		guard let next = _next where next.count > index else { return }
		
		let selection = next[index]
		currentNextTrackSelection = selection
		
		didUpdateSelection(controller: self)
	}
}