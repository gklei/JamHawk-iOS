//
//  CurrentTrackVotingViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/15/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AsyncImageView

protocol CurrentTrackDataSource: class {
	var currentTrackViewModel: PlayerAPIOutputMetadataViewModel? { get }
}

class CurrentTrackViewController: UIViewController {
	weak var dataSource: CurrentTrackDataSource?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .clearColor()
	}
	
	func syncUI() {
	}
}

final class CompactCurrentTrackViewController: CurrentTrackViewController, PlayerStoryboardInstantiable {
	
	@IBOutlet internal var _songTitleLabel: UILabel!
	@IBOutlet internal var _artistNameLabel: UILabel!
	
	override func syncUI() {
		guard let vm = dataSource?.currentTrackViewModel else { return }
		
		_songTitleLabel.text = vm.songTitle
		_artistNameLabel.text = vm.artistName
	}
}

final class LargeCurrentTrackViewController: CurrentTrackViewController, PlayerStoryboardInstantiable {
	
	@IBOutlet internal var _currentTrackLabel: UILabel!
	@IBOutlet internal var _albumArtImageView: AsyncImageView!
	@IBOutlet internal var _albumArtContainerView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_albumArtImageView.backgroundColor = .clearColor()
		_albumArtContainerView.backgroundColor = .clearColor()
		
		_albumArtContainerView.layer.shadowRadius = 12
		_albumArtContainerView.layer.shadowOpacity = 0.5
		_albumArtContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
		_albumArtContainerView.layer.shadowColor = UIColor.blackColor().CGColor
		_albumArtContainerView.layer.shadowPath = UIBezierPath(rect: _albumArtContainerView.bounds).CGPath
	}
	
	override func syncUI() {
		guard let vm = dataSource?.currentTrackViewModel else { return }
		
		_currentTrackLabel.text = vm.artistAndSongTitle
		_albumArtImageView.imageURL = vm.albumArtworkURL
	}
}