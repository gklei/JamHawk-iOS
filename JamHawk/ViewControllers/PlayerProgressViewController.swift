//
//  PlayerProgressViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/12/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerProgressViewController: UIViewController {
	// MARK: - Outlets
	@IBOutlet private var _trailingSpaceProgressConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	var output: PlayerAPIOutput?
	
	// MARK: - Overridden
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		self.output = output
	}
	
	func updateProgress(withTime time: CMTime) {
		let seconds = CMTimeGetSeconds(time)
		guard let totalDuration = output?.track?.duration else { return }
		let progress = CGFloat(seconds) / CGFloat(totalDuration)
		
		let progressWidth = view.bounds.width - (view.bounds.width * progress)
		
		dispatch_async(dispatch_get_main_queue()) {
			self._trailingSpaceProgressConstraint.constant = progressWidth
		}
	}
	
	// MARK: - Private
	private func _resetProgressBar() {
		_trailingSpaceProgressConstraint.constant = view.bounds.width
	}
}
