//
//  SubfilterSelectionViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/17/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

protocol SubfilterSelectionDataSource: class {
	var subfilterViewModels: [SubfilterViewModel] { get }
}

class SubfilterSelectionViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private var _collectionView: UICollectionView!
	@IBOutlet private var _collectionViewHeightConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	weak var dataSource: SubfilterSelectionDataSource?
	
	var viewTappedClosure: () -> Void = {}
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.clipsToBounds = true
		_collectionView.allowsMultipleSelection = true
		
		view.backgroundColor = UIColor(white: 0, alpha: 0.2)
		_collectionView.backgroundColor = .whiteColor()
		_collectionView.layer.masksToBounds = true
		
		_collectionView.dataSource = self
		
		_registerCollectionViewCells()
		_setupCollectionViewLayout()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		_updateCollectionViewHeight()
	}
	
	// MARK: - Setup
	private func _registerCollectionViewCells() {
		let nib = UINib(nibName: SubfilterCell.xibName, bundle: nil)
		_collectionView.registerNib(nib, forCellWithReuseIdentifier: SubfilterCell.reuseID)
	}
	
	private func _setupCollectionViewLayout() {
		let size = UIScreen.mainScreen().bounds.width * 0.24
		let inset = UIScreen.mainScreen().bounds.width * 0.08
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: size, height: size)
		layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
		
		_collectionView.collectionViewLayout = layout
	}
	
	// MARK: - Public
	func syncData() {
		_collectionView.reloadData()
		_updateCollectionViewHeight()
	}
	
	func syncUI() {
		_collectionView.reloadData()
		_updateCollectionViewHeight()
	}
	
	private func _updateCollectionViewHeight() {
		guard let count = dataSource?.subfilterViewModels.count else { return }
		let numRows: CGFloat = ceil(CGFloat(count) / 3.0)
		let layout = self._collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		let height = layout.sectionInset.top + layout.sectionInset.bottom + (layout.itemSize.height * numRows)
		_collectionViewHeightConstraint.constant = min(view.bounds.height, height)
		self.view.setNeedsLayout()
	}
	
	@IBAction private func _viewTapped(recognizer: UIGestureRecognizer) {
		viewTappedClosure()
	}
}

extension SubfilterSelectionViewController: UICollectionViewDataSource {
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource?.subfilterViewModels.count ?? 0
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SubfilterCell.reuseID, forIndexPath: indexPath) as! SubfilterCell
		
		if let viewModels = dataSource?.subfilterViewModels {
			let subfilter = viewModels[indexPath.row]
			cell.update(name: subfilter.name)
		}
		
		return cell
	}
}
