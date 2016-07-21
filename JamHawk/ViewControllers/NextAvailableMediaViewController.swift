//
//  NextAvailableMediaViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

final class NextAvailableMediaViewController: UIViewController, PlayerStoryboardInstantiable {
	
	// MARK: - Outlets
	@IBOutlet private var _collectionView: UICollectionView!
	@IBOutlet private var _nextSongInfoLabel: UILabel!
	
	// MARK: - Properties: Private
	private var _nextAvailableMediaDS: NextAvailableMediaDataSource?
	
	// MARK: - Properties: Public
	var selectedTrack: PlayerAPIOutputMetadata? {
		return _nextAvailableMediaDS?.selectedTrack
	}
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let nib = UINib(nibName: NextAvailableMediaCell.xibName, bundle: nil)
		_collectionView.registerNib(nib, forCellWithReuseIdentifier: NextAvailableMediaCell.reuseID)
		
		_nextAvailableMediaDS = NextAvailableMediaDataSource(collectionView: _collectionView)
		_nextAvailableMediaDS?.selectionClosure = _updateUI
		
		let topBorder = UIView()
		topBorder.backgroundColor = UIColor(white: 1, alpha: 0.4)
		view.addSubview(topBorder)
		
		topBorder.translatesAutoresizingMaskIntoConstraints = false
		topBorder.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
		topBorder.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
		topBorder.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
		topBorder.heightAnchor.constraintEqualToConstant(1).active = true
	}
	
	// MARK: - Private
	private func _updateUI(withTrack track: PlayerAPIOutputMetadata) {
		let vm = PlayerAPIOutputMetadataViewModel(metatdata: track)
		guard let title = vm.artistAndSongTitle else { return }
		
		_nextSongInfoLabel.text = "Next Song: \(title)"
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		_nextAvailableMediaDS?.resetCells()
		_nextAvailableMediaDS?.update(withPlayerAPIOutput: output)
		_nextAvailableMediaDS?.selectFirstTrack()
	}
}
