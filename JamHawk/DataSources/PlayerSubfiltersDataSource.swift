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
		
		let nib = UINib(nibName: PlayerSubfilterCell.xibName, bundle: nil)
		_collectionView.registerNib(nib, forCellWithReuseIdentifier: PlayerSubfilterCell.reuseID)
		
		_collectionView.dataSource = self
		_collectionView.delegate = self
	}
	
	func update(filter filter: PlayerAPIOutputFilter) {
		_filter = filter
		_collectionView.reloadData()
	}
}

extension PlayerSubfiltersDataSource: UICollectionViewDataSource {
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return _filter?.filterNames.count ?? 0
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PlayerSubfilterCell.reuseID, forIndexPath: indexPath) as! PlayerSubfilterCell
		
		if let names = _filter?.filterNames {
			let filterName = names[indexPath.row]
			cell.update(name: filterName)
		}
		
		return cell
	}
}

extension PlayerSubfiltersDataSource: UICollectionViewDelegate {
}