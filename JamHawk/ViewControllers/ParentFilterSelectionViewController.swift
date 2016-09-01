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
	
	var selectedSubfilterViewModels: [SubfilterViewModel] { get }
	
	func selectedSubfilers(atParentIndex index: Int) -> [SubfilterViewModel]
	func selectFilter(atIndex index: Int)
	func resetParentFilterSelection()
}

final class ParentFilterSelectionViewController: UIViewController, PlayerStoryboardInstantiable {
	
	// MARK: - Outlets
	@IBOutlet private var _collectionView: UICollectionView!
	private var _collectionViewLayoutSet = false
	
	// MARK: - Properties
	weak var dataSource: ParentFilterSelectionDataSource?
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		_registerCollectionViewCellType()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		_setupCollectionViewLayoutIfNecessary()
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
	
	private func _setupCollectionViewLayoutIfNecessary() {
		if !_collectionViewLayoutSet {
			_setupCollectionViewLayout()
			_collectionViewLayoutSet = true
		}
	}
	
	// MARK: - Public
	func syncUI() {
		if let selectedIndex = dataSource?.selectedParentFilterIndex {
			let ip = NSIndexPath(forRow: selectedIndex, inSection: 0)
			_collectionView.selectItemAtIndexPath(ip, animated: true, scrollPosition: .CenteredHorizontally)
			_updateCell(atIndexPath: ip)
		} else {
			_collectionView.deselectAllItems()
			let ips = _collectionView.indexPathsForVisibleItems()
			ips.forEach {
				_updateCell(atIndexPath: $0)
			}
		}
	}
	
	func syncData() {
		if let selectedIndex = dataSource?.selectedParentFilterIndex {
			let ip = NSIndexPath(forRow: selectedIndex, inSection: 0)
			_collectionView.selectItemAtIndexPath(ip, animated: true, scrollPosition: .CenteredHorizontally)
			
			guard let cell = _collectionView.cellForItemAtIndexPath(ip) as? ParentFilterCell else { return }
			guard let subfilterViewModels = dataSource?.selectedSubfilterViewModels else { return }
			cell.update(viewSubfilterViewModles: subfilterViewModels)
		} else {
			_collectionView.reloadData()
		}
	}
	
	private func _updateCell(atIndexPath ip: NSIndexPath) {
		guard let cell = _collectionView.cellForItemAtIndexPath(ip) as? ParentFilterCell else { return }
		guard let subfilterViewModels = dataSource?.selectedSubfilers(atParentIndex: ip.row) else { return }
		cell.update(viewSubfilterViewModles: subfilterViewModels)
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
		
		if let selectedSubfilterVMs = dataSource?.selectedSubfilers(atParentIndex: indexPath.row) {
			cell.update(viewSubfilterViewModles: selectedSubfilterVMs)
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
