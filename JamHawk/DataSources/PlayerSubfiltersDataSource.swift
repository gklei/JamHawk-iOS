//
//  PlayerSubfiltersDataSource.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/18/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class PlayerSubfiltersDataSource: NSObject {
	
	// MARK: - Properties
	private let _collectionView: UICollectionView
	private var _filter: PlayerAPIOutputFilter?
	
	init(collectionView: UICollectionView) {
		_collectionView = collectionView
		super.init()
		
		let nib = UINib(nibName: SubfilterCell.xibName, bundle: nil)
		_collectionView.registerNib(nib, forCellWithReuseIdentifier: SubfilterCell.reuseID)
		
		_collectionView.dataSource = self
		_collectionView.delegate = self
	}
	
	func update(filter filter: PlayerAPIOutputFilter, completion: ((finished: Bool) -> Void)? = nil) {
		_filter = filter
		self._collectionView.reloadData()
		_collectionView.performBatchUpdates({}, completion: completion)
	}
}

extension PlayerSubfiltersDataSource: UICollectionViewDataSource {
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return _filter?.filterNames.count ?? 0
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SubfilterCell.reuseID, forIndexPath: indexPath) as! SubfilterCell
		
		if let names = _filter?.filterNames {
			let filterName = names[indexPath.row]
			cell.update(name: filterName)
		}
		
		return cell
	}
}

extension PlayerSubfiltersDataSource: UICollectionViewDelegate {
}