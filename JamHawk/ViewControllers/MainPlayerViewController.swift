//
//  MainPlayerViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AVFoundation
import AsyncImageView
import IncipiaKit

class MainPlayerViewController: UIViewController
{
	// MARK: - Outlets
	@IBOutlet private var _posterImageView: AsyncImageView!
	@IBOutlet private var _songLabel: UILabel!
	@IBOutlet private var _artistLabel: UILabel!
	@IBOutlet private var _albumLabel: UILabel!
	
	@IBOutlet private var _waveformView: UIView!
	
	var player: AVPlayer?
	
	// MARK: - Overridden
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .Default
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		guard let media = output.media else { return }
		guard let url = media.trackURL else { return }
		
		player = AVPlayer(URL: url)
		player?.play()
		
		_posterImageView.showActivityIndicator = true
		_posterImageView.imageURL = media.posterURL
		
		guard let metadata = output.track else { return }
		_songLabel.text = metadata.title
		_artistLabel.text = metadata.artist
		_albumLabel.text = metadata.album
	}
}