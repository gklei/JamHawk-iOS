//
//  FilterSelectionViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/17/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class FilterSelectionViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private var _collectionView: UICollectionView!
	
	// MARK: - Properties
	private var _filter: PlayerAPIOutputFilter?
	private var _playerSubfiltersDS: PlayerSubfiltersDataSource?
	
	var parentFilter: PlayerAPIOutputFilter? {
		return _filter
	}
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_collectionView.allowsMultipleSelection = true
		_setupCollectionViewLayout()
		
		_playerSubfiltersDS = PlayerSubfiltersDataSource(collectionView: _collectionView)
	}
	
	// MARK: - Setup
	private func _setupCollectionViewLayout() {
		let size = UIScreen.mainScreen().bounds.width * 0.24
		let inset = UIScreen.mainScreen().bounds.width * 0.08
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: size, height: size)
		layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
		
		_collectionView.collectionViewLayout = layout
	}
	
	// MARK: - Public
	func update(filter filter: PlayerAPIOutputFilter) {
		guard _filter != filter else { return }
		
		_filter = filter
		_playerSubfiltersDS?.update(filter: filter)
	}
}
