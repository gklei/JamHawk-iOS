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
	private var _layout: UICollectionViewFlowLayout!
	
	var viewTappedClosure: () -> Void = {}
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.clipsToBounds = true
		_collectionView.allowsMultipleSelection = true
		
		view.backgroundColor = UIColor(white: 0, alpha: 0.2)
		_collectionView.backgroundColor = .whiteColor()
		_collectionView.layer.masksToBounds = true
		
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
		
		_layout = UICollectionViewFlowLayout()
		_layout.itemSize = CGSize(width: size, height: size)
		_layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
		
		_collectionView.collectionViewLayout = _layout
		view.setNeedsLayout()
	}
	
	// MARK: - Public
	func syncData() {
		dispatch_async(dispatch_get_main_queue()) {
			self._collectionView.reloadData()
			self.view.setNeedsLayout()
		}
	}
	
	func syncUI() {
		dispatch_async(dispatch_get_main_queue()) {
			self._collectionView.reloadData()
			self.view.setNeedsLayout()
		}
	}
	
	private func _updateCollectionViewHeight() {
		let count = dataSource?.subfilterViewModels.count ?? 0
		let numRows: CGFloat = ceil(CGFloat(count) / 3.0)
		let height = _layout.sectionInset.top + _layout.sectionInset.bottom + (_layout.itemSize.height * numRows)
		_collectionViewHeightConstraint.constant = min(view.bounds.height, height)
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

extension SubfilterSelectionViewController: UICollectionViewDelegate {
}
