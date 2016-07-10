//
//  MainPlayerViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AVFoundation

class MainPlayerViewController: UIViewController
{
	var player: AVPlayer?
	
	// MARK: - Properties
	var playerAPIOutput: PlayerAPIOutput?
	
	// MARK: - Overridden
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		guard let url = output.mediaURL else { return }
		
		player = AVPlayer(URL: url)
		player?.play()
	}
}
