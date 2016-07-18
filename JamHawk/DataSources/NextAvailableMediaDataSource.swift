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
	private var _output: PlayerAPIOutput?
	
	init(collectionView: UICollectionView) {
		_collectionView = collectionView
		super.init()
		
		_collectionView.dataSource = self
		_collectionView.delegate = self
	}
	
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		_output = output
		_collectionView.reloadSections(NSIndexSet(index: 0))
	}
	
	func resetCells() {
		_collectionView.visibleCells().flatMap({$0 as? NextAvailableMediaCell}).forEach { cell in
			cell?.reset()
		}
	}
}

extension NextAvailableMediaDataSource: UICollectionViewDataSource {
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return _output?.next?.count ?? 0
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cellID = NextAvailableMediaCell.reuseID
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! NextAvailableMediaCell
		
		if let next = _output?.next {
			let metadata = next[indexPath.row]
			let vm = PlayerAPIOutputMetadataViewModel(metatdata: metadata)
			cell.update(withViewModel: vm)
		}
		
		return cell
	}
}

extension NextAvailableMediaDataSource: UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
	{
		let cellWidth: CGFloat = 48
		let numberOfCells: CGFloat = CGFloat(_output?.next?.count ?? 0)
		let cellSpacing: CGFloat = 11
		
		let viewWidth = UIScreen.mainScreen().bounds.width
		let totalContentWidth = numberOfCells * cellWidth + ((numberOfCells - 1) * cellSpacing)
		
		var leftEdgeInset = (viewWidth - totalContentWidth) * 0.5
		leftEdgeInset = max(leftEdgeInset, 0)
		
		return UIEdgeInsets(top: 0, left: leftEdgeInset, bottom: 0, right: leftEdgeInset)
	}
}
