//
//  CurrentTrackVotingViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/15/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol CurrentTrackVotingViewControllerDelegate: class {
	func currentTrackVotingViewControllerUpvoteButtonPressed(forTrack track: PlayerAPIOutputMetadata, controller: CurrentTrackVotingViewController)
	func currentTrackVotingViewControllerDownvoteButtonPressed(forTrack track: PlayerAPIOutputMetadata, controller: CurrentTrackVotingViewController)
}

class CurrentTrackVotingViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet internal var _songTitleLabel: UILabel!
	@IBOutlet internal var _artistNameLabel: UILabel!
	
	@IBOutlet internal var _upvoteButton: UIButton!
	@IBOutlet internal var _downvoteButton: UIButton!
	
	// MARK: - Properties
	weak var delegate: CurrentTrackVotingViewControllerDelegate?
	private var _output: PlayerAPIOutput?
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.clearColor()
		_setupButtons()
	}
	
	// MARK: - Setup
	private func _setupButtons() {
		let buttonSize = _upvoteButton.bounds.size
		_upvoteButton.layer.cornerRadius = min(buttonSize.width, buttonSize.height) * 0.5
		_downvoteButton.layer.cornerRadius = min(buttonSize.width, buttonSize.height) * 0.5
		
		_upvoteButton.layer.borderWidth = 2.0
		_downvoteButton.layer.borderWidth = 2.0
		
		_upvoteButton.layer.borderColor = UIColor.whiteColor().CGColor
		_downvoteButton.layer.borderColor = UIColor.whiteColor().CGColor
		_downvoteButton.backgroundColor = UIColor.clearColor()
	}
	
	@IBAction private func _downvoteButtonPressed() {
		guard let track = _output?.track else { return }
		delegate?.currentTrackVotingViewControllerDownvoteButtonPressed(forTrack: track, controller: self)
	}
	
	@IBAction private func _upvoteButtonPressed() {
		guard let track = _output?.track else { return }
		delegate?.currentTrackVotingViewControllerUpvoteButtonPressed(forTrack: track, controller: self)
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		guard let metadata = output.track else { return }
		
		let vm = PlayerAPIOutputMetadataViewModel(metatdata: metadata)
		update(withViewModel: vm)
	}
	
	// MARK: - Internal
	internal func update(withViewModel vm: PlayerAPIOutputMetadataViewModel) {
		_songTitleLabel.text = vm.songTitle
		_artistNameLabel.text = vm.artistName
	}
}

final class CurrentTrackVotingLargeViewController: CurrentTrackVotingViewController, PlayerStoryboardInstantiable {
	
	// MARK: - Outlets
	@IBOutlet internal var _albumTitleLabel: UILabel!
	
	// MARK: - Overridden
	override func update(withViewModel vm: PlayerAPIOutputMetadataViewModel) {
		super.update(withViewModel: vm)
		_albumTitleLabel.text = vm.albumTitle
	}
}

final class CurrentTrackVotingSmallViewController: CurrentTrackVotingViewController, PlayerStoryboardInstantiable {
	
	// MARK: - Overriden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor(white: 0, alpha: 0.3)
		_upvoteButton.backgroundColor = UIColor.clearColor()
	}
}