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
	}

	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		_output = output
		_collectionView.reloadData()
	}
}

extension PlayerFiltersDataSource: UICollectionViewDataSource {
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ParentFilterCell", forIndexPath: indexPath)
		cell.contentView.backgroundColor = UIColor(white: 0, alpha: 0.5)
		return cell
	}
}

extension PlayerFiltersDataSource: UICollectionViewDelegate {
}
