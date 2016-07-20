//
//  SubfilterSelectionViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/17/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class SubfilterSelectionViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private var _collectionView: UICollectionView!
	@IBOutlet private var _collectionViewHeightConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	private var _filter: PlayerAPIOutputFilter?
	private var _playerSubfiltersDS: PlayerSubfiltersDataSource?
	
	var parentFilter: PlayerAPIOutputFilter? {
		return _filter
	}
	
	// MARK: - Overridden
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_collectionView.allowsMultipleSelection = true
		
		view.backgroundColor = .clearColor()
		_collectionView.backgroundColor = .whiteColor()
		
		_setupCollectionViewLayout()
		_playerSubfiltersDS = PlayerSubfiltersDataSource(collectionView: _collectionView)
		
		_collectionViewHeightConstraint.constant = 0
	}
	
	// MARK: - Setup
	private func _setupCollectionViewLayout() {
		let size = UIScreen.mainScreen().bounds.width * 0.24
		let inset = UIScreen.mainScreen().bounds.width * 0.08
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: size, height: size)
		layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
		
		_collectionView.collectionViewLayout = layout
	}
	
	// MARK: - Public
	func update(filter filter: PlayerAPIOutputFilter) {
		guard _filter != filter else { return }
		
		_filter = filter
		_playerSubfiltersDS?.update(filter: filter) { [weak self] finished in
			if let contentHeight = self?._collectionView.contentSize.height,
				let viewHeight = self?.view.bounds.height {
				let constant = min(viewHeight, contentHeight)
				
				self?._collectionViewHeightConstraint.constant = constant
				UIView.animateWithDuration(0.2, animations: {
					self?.view.layoutIfNeeded()
				})
			}
		}
	}
	
	func collapseFilterSelection() {
		_collectionViewHeightConstraint.constant = 0
		UIView.animateWithDuration(0.2, animations: {
			self.view.layoutIfNeeded()
		})
	}
}
