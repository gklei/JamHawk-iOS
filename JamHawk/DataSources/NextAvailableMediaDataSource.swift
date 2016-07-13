//
//  NextAvailableMediaDataSource.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/13/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class NextAvailableMediaDataSource: NSObject {
	
	// MARK: - Properties
	private let _collectionView: UICollectionView
	var output: PlayerAPIOutput? {
		didSet {
			_collectionView.reloadData()
		}
	}
	
	init(collectionView: UICollectionView) {
		_collectionView = collectionView
		super.init()
		
		_collectionView.dataSource = self
		_collectionView.delegate = self
	}
}

extension NextAvailableMediaDataSource: UICollectionViewDataSource {
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return output?.next?.count ?? 0
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cellID = NextAvailableMediaCell.reuseID
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! NextAvailableMediaCell
		
		if let next = output?.next {
			let metadata = next[indexPath.row]
			cell.update(withMetatdata: metadata)
		}
		
		return cell
	}
}

extension NextAvailableMediaDataSource: UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
	{
		let cellWidth: CGFloat = 70
		let numberOfCells: CGFloat = CGFloat(output?.next?.count ?? 0)
		let cellSpacing: CGFloat = 10
		
		let viewWidth = UIScreen.mainScreen().bounds.width
		let totalContentWidth = numberOfCells * cellWidth + ((numberOfCells - 1) * cellSpacing)
		
		var leftEdgeInset = (viewWidth - totalContentWidth) * 0.5
		leftEdgeInset = max(leftEdgeInset, 0)
		
		return UIEdgeInsets(top: 10, left: leftEdgeInset, bottom: 10, right: leftEdgeInset)
	}

}
