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
	
	var selectionClosure: (track: PlayerAPIOutputMetadata) -> Void = {_ in}
	var selectedTrack: PlayerAPIOutputMetadata? {
		guard let ip = _collectionView.indexPathsForSelectedItems()?.first else { return nil }
		guard ip.row < _output?.next?.count else { return nil }
		return _output?.next?[ip.row]
	}
	
	init(collectionView: UICollectionView) {
		_collectionView = collectionView
		super.init()
		
		_collectionView.dataSource = self
		_collectionView.delegate = self
		
		let layout = UICollectionViewFlowLayout()
		
		let size = _collectionView.bounds.height
		layout.itemSize = CGSize(width: size, height: size)
		layout.minimumLineSpacing = 28.0
		layout.scrollDirection = .Horizontal
		
		_collectionView.collectionViewLayout = layout
	}
	
	func update(withPlayerAPIOutput output: PlayerAPIOutput) {
		_output = output
		_collectionView.reloadSections(NSIndexSet(index: 0))
	}
	
	func selectFirstTrack() {
		guard _collectionView.numberOfItemsInSection(0) > 1 else { return }
		
		let ip = NSIndexPath(forRow: 0, inSection: 0)
		_collectionView.selectItemAtIndexPath(ip, animated: false, scrollPosition: .None)
		collectionView(_collectionView, didSelectItemAtIndexPath: ip)
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
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let next = _output?.next {
			let metadata = next[indexPath.row]
			selectionClosure(track: metadata)
		}
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
	{
		let cellWidth = collectionView.bounds.height
		let numberOfCells: CGFloat = CGFloat(_output?.next?.count ?? 0)
		let cellSpacing: CGFloat = 28.0
		
		let viewWidth = UIScreen.mainScreen().bounds.width
		let totalContentWidth = numberOfCells * cellWidth + ((numberOfCells - 1) * cellSpacing)
		
		var leftEdgeInset = (viewWidth - totalContentWidth) * 0.5
		leftEdgeInset = max(leftEdgeInset, 0)
		
		return UIEdgeInsets(top: 0, left: leftEdgeInset, bottom: 0, right: leftEdgeInset)
	}
}
