//
//  ParentFilterSelectionViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol ParentFilterSelectionDataSource: class {
	var selectedParentFilterIndex: Int? { get }
	var parentFilterViewModels: [PlayerAPIOutputFilterViewModel] { get }
	func selectFilter(atIndex index: Int)
	func resetParentFilterSelection()
}

final class ParentFilterSelectionViewController: UIViewController, PlayerStoryboardInstantiable {
	
	// MARK: - Outlets
	@IBOutlet private var _collectionView: UICollectionView!
	
	// MARK: - Properties
	weak var dataSource: ParentFilterSelectionDataSource?
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_registerCollectionViewCellType()
		_setupCollectionViewLayout()
	}
	
	// MARK: - Private
	private func _registerCollectionViewCellType() {
		let nib = UINib(nibName: ParentFilterCell.xibName, bundle: nil)
		_collectionView.registerNib(nib, forCellWithReuseIdentifier: ParentFilterCell.reuseID)
	}
	
	private func _setupCollectionViewLayout() {
		let layout = UICollectionViewFlowLayout()
		let size = _collectionView.bounds.height
		layout.itemSize = CGSize(width: 182, height: size)
		layout.minimumLineSpacing = 0
		layout.scrollDirection = .Horizontal
		_collectionView.collectionViewLayout = layout
	}
	
	// MARK: - Public
	func syncUI() {
		if let selectedIndex = dataSource?.selectedParentFilterIndex {
			let ip = NSIndexPath(forRow: selectedIndex, inSection: 0)
			_collectionView.selectItemAtIndexPath(ip, animated: true, scrollPosition: .CenteredHorizontally)
		} else {
			_collectionView.deselectAllItems()
		}
	}
	
	func syncData() {
		_collectionView.reloadData()
	}
}

extension ParentFilterSelectionViewController: UICollectionViewDataSource {
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource?.parentFilterViewModels.count ?? 0
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ParentFilterCell.reuseID, forIndexPath: indexPath) as! ParentFilterCell
		
		if let viewModels = dataSource?.parentFilterViewModels {
			let vm = viewModels[indexPath.row]
			cell.update(withViewModel: vm)
			
			if viewModels.first == vm {
				cell.showLeftBorder = false
				cell.showRightBorder = true
			} else if viewModels.last == vm {
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

extension ParentFilterSelectionViewController: UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		if let index = dataSource?.selectedParentFilterIndex where index == indexPath.row {
			dataSource?.resetParentFilterSelection()
		} else {
			dataSource?.selectFilter(atIndex: indexPath.row)
		}
	}
}
