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
	
	private let _jamhawkTitleViewController = JamhawkTitleViewController()
	
	private var _playerFiltersVC: PlayerFiltersViewController?
	private var _nextAvailableMediaVC: NextAvailableMediaViewController?
	private var _playerControlsVC: PlayerControlsViewController?
	
	var nextTrackButtonPressed: () -> Void = {}
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let titleViewFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 40)
		let titleView = _jamhawkTitleViewController.view
		titleView.frame = titleViewFrame
		navigationItem.titleView = titleView
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
		removeRightBarItem()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		let color = UIColor(white: 0, alpha: 0.3)
		navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color), forBarMetrics: .Default)
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
		default: break
		}
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		self.output = output
		
		_playerFiltersVC?.update(withPlayerAPIOutput: output)
		_nextAvailableMediaVC?.update(withPlayerAPIOutput: output)
		_playerControlsVC?.update(withPlayerAPIOutput: output)
		
		_updateUI(withOutput: output)
	}
	
	// MARK: - Private
	private func _updateUI(withOutput output: PlayerAPIOutput) {
		let viewModel = PlayerAPIOutputViewModel(output: output)
		_backgroundImageView.imageURL = viewModel.posterURL
	}
}

extension MainPlayerViewController: PlayerControlsViewControllerDelegate {
	func playerControlsViewController(controller: PlayerControlsViewController, executedAction action: PlayerControlsActionType) {
		if action == .NextTrack {
			nextTrackButtonPressed()
		}
	}
}