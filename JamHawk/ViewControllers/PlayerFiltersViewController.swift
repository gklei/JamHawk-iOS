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
}
