//
//  PlayerSystemController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import AVFoundation

final class PlayerSystemController: SystemController<PlayerAPIOutputMedia> {
	private var _media: PlayerAPIOutputMedia?
	private let _player = AVPlayer()
	
	var didUpdateModel: (controller: PlayerSystemController) -> Void = {_ in}
	var didUpdateSelection: (controller: PlayerSystemController) -> Void = {_ in}
	
	var needMedia: Bool = false
	
	override func update(withModel model: PlayerAPIOutputMedia?) {
		guard let model = model, updatedItem = AVPlayerItem(media: model) else { return }
		
		_media = model
		_player.replaceCurrentItemWithPlayerItem(updatedItem)
		_player.play()
		
		didUpdateModel(controller: self)
	}
}