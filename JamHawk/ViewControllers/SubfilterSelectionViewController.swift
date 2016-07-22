//
//  SubfilterSelectionViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/17/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class SubfilterSelectionViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private var _collectionView: UICollectionView!
	@IBOutlet private var _collectionViewHeightConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	private var _filter: PlayerAPIOutputFilter?
	private var _playerSubfiltersDS: PlayerSubfiltersDataSource?
	
	var parentFilter: PlayerAPIOutputFilter? {
		return _filter
	}
	
	var selectedSubfilterIDs: [PlayerAPIFilterID] {
		return _playerSubfiltersDS?.selectedSubfilterIDs ?? []
	}
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.clipsToBounds = true
		_collectionView.allowsMultipleSelection = true
		
		view.backgroundColor = UIColor(white: 0, alpha: 0.2)
		_collectionView.backgroundColor = .whiteColor()
		_collectionView.layer.masksToBounds = true
		
		_setupCollectionViewLayout()
		_playerSubfiltersDS = PlayerSubfiltersDataSource(collectionView: _collectionView)
		_collectionViewHeightConstraint.constant = view.bounds.height
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
	func update(filter filter: PlayerAPIOutputFilter, selectedSubfilters: [PlayerAPIFilterID]) {
		guard _filter != filter else { return }
		
		_filter = filter
		_playerSubfiltersDS?.update(filter: filter)
		
		_playerSubfiltersDS?.selectSubfilters(withIDs: selectedSubfilters)
		
		// Manually update the collection view height
		let numRows: CGFloat = ceil(CGFloat(filter.filterIDs.count) / 3.0)
		let layout = self._collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		let height = layout.sectionInset.top + layout.sectionInset.bottom + (layout.itemSize.height * numRows)
		self._collectionViewHeightConstraint.constant = min(view.bounds.height, height)
	}
	
	func reset() {
		_filter = nil
	}
}
