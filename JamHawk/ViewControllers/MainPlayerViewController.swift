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
	@IBOutlet private var _backgroundImageView: AsyncImageView!
	@IBOutlet private var _nextAvailableCollectionView: UICollectionView!
	
	// MARK: - Properties
	var output: PlayerAPIOutput?
	
	private var _nextAvailableMediaDS: NextAvailableMediaDataSource?
	private let _jamhawkTitleViewController = JamhawkTitleViewController()
	private var _playerControlsVC: PlayerControlsViewController?
	
	var nextTrackButtonPressed: () -> Void = {}
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let nib = UINib(nibName: NextAvailableMediaCell.xibName, bundle: nil)
		_nextAvailableCollectionView.registerNib(nib, forCellWithReuseIdentifier: NextAvailableMediaCell.reuseID)
		
		_nextAvailableMediaDS = NextAvailableMediaDataSource(collectionView: _nextAvailableCollectionView)
		
		let titleViewFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 40)
		let titleView = _jamhawkTitleViewController.view
		titleView.frame = titleViewFrame
		navigationItem.titleView = titleView
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		removeLeftBarItem()
		removeRightBarItem()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		resetNavBarTransparency()
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.destinationViewController {
		case is PlayerControlsViewController:
			_playerControlsVC = segue.destinationViewController as? PlayerControlsViewController
			_playerControlsVC?.delegate = self
		default: break
		}
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		self.output = output
		
		_playerControlsVC?.update(withPlayerAPIOutput: output)
		_nextAvailableMediaDS?.update(withPlayerAPIOutput: output)
		
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