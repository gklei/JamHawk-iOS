//
//  PlayerFiltersViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class PlayerFiltersViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private var _collectionView: UICollectionView!
	
	// MARK: - Properties
	var selectionClosure: (filter: PlayerAPIOutputFilter) -> Void = {_ in} {
		didSet {
			_filtersDS?.selectionClosure = selectionClosure
		}
	}
	
	private var _filtersDS: PlayerFiltersDataSource?
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		_filtersDS = PlayerFiltersDataSource(collectionView: _collectionView)
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		_filtersDS?.update(withPlayerAPIOutput: output)
	}
	
	func scroll(toFilter filter: PlayerAPIOutputFilter) {
		guard let ip = _filtersDS?.indexPath(forFilter: filter) else { return }
		_collectionView.scrollToItemAtIndexPath(ip, atScrollPosition: .CenteredHorizontally, animated: true)
	}
}
