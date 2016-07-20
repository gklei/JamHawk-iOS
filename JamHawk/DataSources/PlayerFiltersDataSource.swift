//
//  PlayerFiltersDataSource.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

typealias FilterSelectionClosure = (filter: PlayerAPIOutputFilter) -> Void

class PlayerFiltersDataSource: NSObject {
	
	// MARK: - Properties
	private var _output: PlayerAPIOutput?
	private let _collectionView: UICollectionView
	
	var selectionClosure: FilterSelectionClosure = {_ in}
	
	init(collectionView: UICollectionView) {
		_collectionView = collectionView
		super.init()
		
		_collectionView.dataSource = self
		_collectionView.delegate = self
		
		let layout = UICollectionViewFlowLayout()
		let size = _collectionView.bounds.height
		layout.itemSize = CGSize(width: 182, height: size)
		layout.minimumLineSpacing = 0
		layout.scrollDirection = .Horizontal
		_collectionView.collectionViewLayout = layout
		
		let nib = UINib(nibName: ParentFilterCell.xibName, bundle: nil)
		_collectionView.registerNib(nib, forCellWithReuseIdentifier: ParentFilterCell.reuseID)
	}
	
	func indexPath(forFilter filter: PlayerAPIOutputFilter) -> NSIndexPath? {
		guard let index = _output?.filters?.available?.indexOf(filter) else { return nil }
		return NSIndexPath(forRow: index, inSection: 0)
	}

	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		_output = output
		_collectionView.reloadData()
	}
}

extension PlayerFiltersDataSource: UICollectionViewDataSource {
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return _output?.filters?.available?.count ?? 0
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ParentFilterCell.reuseID, forIndexPath: indexPath) as! ParentFilterCell
		
		if let available = _output?.filters?.available {
			let filter = available[indexPath.row]
			let vm = PlayerAPIOutputFilterViewModel(filter: filter)
			cell.update(withViewModel: vm)
			
			if available.first == filter {
				cell.showLeftBorder = false
				cell.showRightBorder = true
			} else if available.last == filter {
				cell.showRightBorder = false
				cell.showLeftBorder = true
			} else {
				cell.showLeftBorder = true
				cell.showRightBorder = true
			}
		}
		return cell
	}
}

extension PlayerFiltersDataSource: UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let available = _output?.filters?.available {
			let filter = available[indexPath.row]
			selectionClosure(filter: filter)
		}
	}
}
