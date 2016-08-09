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
	var selectedSubfilterIndicies: [Int] { get }
	
	func selectSubfilter(atIndex index: Int)
	func deselectSubfilter(atIndex index: Int)
}

class SubfilterSelectionViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private var _collectionView: UICollectionView!
	@IBOutlet private var _shadowView: UIView!
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
		
		_shadowView.layer.shadowRadius = 12
		_shadowView.layer.shadowOpacity = 0.3
		_shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
		_shadowView.layer.shadowColor = UIColor.blackColor().CGColor
		
		_registerCollectionViewCells()
		_setupCollectionViewLayout()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		_updateCollectionViewHeight()
		
		let height = _collectionViewHeightConstraint.constant
		let rect = CGRect(x: 0, y: 0, width: _collectionView.bounds.width, height: height)
		_shadowView.layer.shadowPath = UIBezierPath(rect: rect).CGPath
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
		_layout.minimumLineSpacing = inset * 0.5
		
		_collectionView.collectionViewLayout = _layout
		view.setNeedsLayout()
	}
	
	// MARK: - Public
	func syncData() {
		dispatch_async(dispatch_get_main_queue()) {
			self._collectionView.reloadData()
			self.dataSource?.selectedSubfilterIndicies.forEach {
				let ip = NSIndexPath(forRow: $0, inSection: 0)
				self._collectionView.selectItemAtIndexPath(ip, animated: true, scrollPosition: .None)
			}
			self.view.setNeedsLayout()
		}
	}
	
	private func _updateCollectionViewHeight() {
		let count = dataSource?.subfilterViewModels.count ?? 0
		let numRows: CGFloat = ceil(CGFloat(count) / 3.0)
		let height = _layout.sectionInset.top + _layout.sectionInset.bottom + (_layout.itemSize.height * numRows) + (_layout.minimumLineSpacing * (numRows - 1))
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
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		dataSource?.selectSubfilter(atIndex: indexPath.row)
	}
	
	func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
		dataSource?.deselectSubfilter(atIndex: indexPath.row)
	}
}
