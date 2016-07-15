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

class MainPlayerViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private var _backgroundImageView: AsyncImageView!
	
	// MARK: - Properties
	var output: PlayerAPIOutput?
	
	private var _playerFiltersVC: PlayerFiltersViewController?
	private var _currentTrackVotingVC: CurrentTrackVotingViewController?
	private var _nextAvailableMediaVC: NextAvailableMediaViewController?
	private var _playerControlsVC: PlayerControlsViewController?
	
	var nextTrackButtonPressed: () -> Void = {}
	
	// MARK: - Overridden
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
		removeRightBarItem()
		_setupTitleView()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let destinationVC = segue.destinationViewController
		switch destinationVC {
		case is PlayerControlsViewController:
			_playerControlsVC = destinationVC as? PlayerControlsViewController
			_playerControlsVC?.delegate = self
		case is NextAvailableMediaViewController:
			_nextAvailableMediaVC = destinationVC as? NextAvailableMediaViewController
		case is PlayerFiltersViewController:
			_playerFiltersVC = destinationVC as? PlayerFiltersViewController
		case is CurrentTrackVotingViewController:
			_currentTrackVotingVC = destinationVC as? CurrentTrackVotingViewController
		default: break
		}
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		self.output = output
		
		_playerFiltersVC?.update(withPlayerAPIOutput: output)
		_currentTrackVotingVC?.update(withPlayerAPIOutput: output)
		_nextAvailableMediaVC?.update(withPlayerAPIOutput: output)
		_playerControlsVC?.update(withPlayerAPIOutput: output)
		
		_updateUI(withOutput: output)
	}
	
	// MARK: - Private
	private func _updateUI(withOutput output: PlayerAPIOutput) {
		guard let media = output.media else { return }
		
		let vm = PlayerAPIOutputMediaViewModel(media: media)
		_backgroundImageView.imageURL = vm.posterURL
	}
	
	private func _setupTitleView() {
		let titleViewFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 40)
		let titleView = JamhawkTitleViewController().view
		titleView.frame = titleViewFrame
		navigationItem.titleView = titleView
	}
}

extension MainPlayerViewController: PlayerControlsViewControllerDelegate {
	func playerControlsViewController(controller: PlayerControlsViewController, executedAction action: PlayerControlsActionType) {
		if action == .NextTrack {
			nextTrackButtonPressed()
		}
	}
}