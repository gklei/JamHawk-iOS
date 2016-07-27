//
//  PlayerProgressViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/12/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AVFoundation

private let k60FramesPerSec = CMTimeMakeWithSeconds(1.0 / 60.0, Int32(NSEC_PER_SEC))

class PlayerProgressViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private var _trailingSpaceProgressConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	var output: PlayerAPIOutput?
	private var _timeObserver: AnyObject?
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		resetProgressBar()
	}
	
	// MARK: - Public
	func updateProgress(zeroToOneValue: CGFloat) {
		let trailingSpaceConstant = view.bounds.width * (1 - zeroToOneValue)
		_trailingSpaceProgressConstraint.constant = trailingSpaceConstant
	}
	
	func resetProgressBar() {
		_trailingSpaceProgressConstraint.constant = view.bounds.width
	}
}
