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
		
		let topBorder = view.addBorder(withSize: 1, toEdge: .Top)
		topBorder?.backgroundColor = UIColor(white: 1, alpha: 0.4)
	}
	
	// MARK: - Private
	private func _updateUI(withTrack track: PlayerAPIOutputMetadata) {
		let vm = PlayerAPIOutputMetadataViewModel(metadata: track)
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
