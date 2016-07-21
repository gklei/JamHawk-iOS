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
	
	var selectedSubfilterIDs: [PlayerAPIFilterID] {
		return _collectionView.indexPathsForSelectedItems()?.flatMap { _subfilterID(forIndexPath: $0) } ?? []
	}
	
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
	
	func selectSubfilters(withIDs selectedIDs: [PlayerAPIFilterID]) {
		guard let ids = _filter?.filterIDs else { return }
		for id in selectedIDs {
			guard let index = ids.indexOf(id) else { continue }
			let ip = NSIndexPath(forRow: index, inSection: 0)
			_collectionView.selectItemAtIndexPath(ip, animated: false, scrollPosition: .None)
		}
	}
	
	private func _subfilterID(forIndexPath indexPath: NSIndexPath) -> PlayerAPIFilterID? {
		guard let ids = _filter?.filterIDs else { return nil }
		guard ids.count > indexPath.row else { return nil }
		let id = ids[indexPath.row]
		return id
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