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
	private var _filtersDataSource: PlayerFiltersDataSource?
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		_filtersDataSource = PlayerFiltersDataSource(collectionView: _collectionView)
	}
	
	// MARK: - Public
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		_filtersDataSource?.update(withPlayerAPIOutput: output)
	}
}
