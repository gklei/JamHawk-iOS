//
//  PlayerFiltersDataSource.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class PlayerFiltersDataSource: NSObject {
	
	// MARK: - Properties
	private var _output: PlayerAPIOutput?
	private let _collectionView: UICollectionView
	
	init(collectionView: UICollectionView) {
		_collectionView = collectionView
		super.init()
		
		_collectionView.dataSource = self
		_collectionView.delegate = self
		
		let nib = UINib(nibName: ParentFilterCell.xibName, bundle: nil)
		_collectionView.registerNib(nib, forCellWithReuseIdentifier: ParentFilterCell.reuseID)
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
			cell.update(withFilter: filter)
		}
		return cell
	}
}

extension PlayerFiltersDataSource: UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let available = _output?.filters?.available {
			let filter = available[indexPath.row]
			print("Options for \(filter.label): \(filter.filterNames)")
		}
	}
}
