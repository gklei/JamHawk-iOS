//
//  ParentFilterCell.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ParentFilterCell: UICollectionViewCell {
	
	// MARK: - Outlets
	@IBOutlet private var _filterNameLabel: UILabel!
	@IBOutlet private var _filterSelectionLabel: UILabel!
	@IBOutlet private var _downArrowImageView: UIImageView!
	
	private let _leftBorder = UIView()
	private let _rightBorder = UIView()
	private let _borderColor = UIColor(white: 1, alpha: 0.4)
	
	var showLeftBorder: Bool = true {
		didSet {
			_leftBorder.hidden = !showLeftBorder
		}
	}
	
	var showRightBorder: Bool = true {
		didSet {
			_rightBorder.hidden = !showRightBorder
		}
	}
	
	// MARK: - Properties
	static let reuseID = "ParentFilterCell"
	static let xibName = "ParentFilterCell"
	
	// MARK: - Overridden
	override func awakeFromNib() {
		super.awakeFromNib()
		backgroundColor = .clearColor()
		_setupBorders()
	}
	
	// MARK: - Public
	func update(withViewModel vm: PlayerAPIOutputFilterViewModel) {
		_filterNameLabel.text = vm.filterName
		_filterSelectionLabel.text = "No Selection"
	}
}

extension ParentFilterCell {
	private func _setupBorders() {
		let bottomBorder = UIView()
		bottomBorder.backgroundColor = _borderColor
		addSubview(bottomBorder)
		
		bottomBorder.translatesAutoresizingMaskIntoConstraints = false
		bottomBorder.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
		bottomBorder.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
		bottomBorder.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
		bottomBorder.heightAnchor.constraintEqualToConstant(1).active = true
		
		let topBorder = UIView()
		topBorder.backgroundColor = _borderColor
		addSubview(topBorder)
		
		topBorder.translatesAutoresizingMaskIntoConstraints = false
		topBorder.topAnchor.constraintEqualToAnchor(topAnchor).active = true
		topBorder.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
		topBorder.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
		topBorder.heightAnchor.constraintEqualToConstant(1).active = true
		
		_leftBorder.backgroundColor = _borderColor
		addSubview(_leftBorder)
		
		_leftBorder.translatesAutoresizingMaskIntoConstraints = false
		_leftBorder.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
		_leftBorder.topAnchor.constraintEqualToAnchor(topAnchor).active = true
		_leftBorder.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
		_leftBorder.widthAnchor.constraintEqualToConstant(0.5).active = true
		
		addSubview(_rightBorder)
		_rightBorder.backgroundColor = _borderColor
		_rightBorder.translatesAutoresizingMaskIntoConstraints = false
		_rightBorder.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
		_rightBorder.topAnchor.constraintEqualToAnchor(topAnchor).active = true
		_rightBorder.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
		_rightBorder.widthAnchor.constraintEqualToConstant(0.5).active = true
	}
}
