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
	private let _highlightedBackgroundView = UIView()
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
		_downArrowImageView.tintColor = .whiteColor()
		_setupBorders()
	}
	
	// MARK: - Public
	func update(withViewModel vm: PlayerAPIOutputFilterViewModel) {
		_filterNameLabel.text = vm.filterName
		_filterSelectionLabel.text = "No Selection"
		
		var filterSelectionText = ""
		vm.selectedSubfilterNames.forEach {
			filterSelectionText += "\($0)"
			if vm.selectedSubfilterNames.last != $0 {
				filterSelectionText += ", "
			}
		}
		
		filterSelectionText = filterSelectionText == "" ? "No Selection" : filterSelectionText
		_filterSelectionLabel.text = filterSelectionText
	}
	
	func update(viewSubfilterViewModles viewModels: [SubfilterViewModel]) {
		var filterSelectionText = ""
		viewModels.forEach {
			filterSelectionText += "\($0.name)"
			if viewModels.last != $0 {
				filterSelectionText += ", "
			}
		}
		
		filterSelectionText = filterSelectionText == "" ? "No Selection" : filterSelectionText
		_filterSelectionLabel.text = filterSelectionText
 	}
}

extension ParentFilterCell {
	private func _setupBorders() {
		let halfPixelWidth = ((1.0 / UIScreen.mainScreen().scale) / 2) * 2
		
		let bottomBorder = addBorder(withSize: 1, toEdge: .Bottom)
		bottomBorder?.backgroundColor = _borderColor
		
		let topBorder = addBorder(withSize: 1, toEdge: .Top)
		topBorder?.backgroundColor = _borderColor
		
		_leftBorder.backgroundColor = _borderColor
		addSubview(_leftBorder)
		
		_leftBorder.translatesAutoresizingMaskIntoConstraints = false
		_leftBorder.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
		_leftBorder.topAnchor.constraintEqualToAnchor(topAnchor, constant: 1).active = true
		_leftBorder.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -1).active = true
		_leftBorder.widthAnchor.constraintEqualToConstant(halfPixelWidth).active = true
		
		addSubview(_rightBorder)
		_rightBorder.backgroundColor = _borderColor
		_rightBorder.translatesAutoresizingMaskIntoConstraints = false
		_rightBorder.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
		_rightBorder.topAnchor.constraintEqualToAnchor(topAnchor, constant: 1).active = true
		_rightBorder.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -1).active = true
		_rightBorder.widthAnchor.constraintEqualToConstant(halfPixelWidth).active = true

		insertSubview(_highlightedBackgroundView, atIndex: 0)
		_highlightedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
		_highlightedBackgroundView.leftAnchor.constraintEqualToAnchor(_leftBorder.rightAnchor).active = true
		_highlightedBackgroundView.topAnchor.constraintEqualToAnchor(topBorder!.bottomAnchor).active = true
		_highlightedBackgroundView.rightAnchor.constraintEqualToAnchor(_rightBorder.leftAnchor).active = true
		_highlightedBackgroundView.bottomAnchor.constraintEqualToAnchor(bottomBorder!.topAnchor).active = true
	}
	
	override var selected: Bool {
		didSet {
			contentView.backgroundColor = selected ? .whiteColor() : .clearColor()
			_filterNameLabel.textColor = selected ? .jmhTurquoiseColor() : .whiteColor()
			_filterSelectionLabel.textColor = selected ? .jmhTurquoiseColor() : .whiteColor()
			_downArrowImageView.tintColor = selected ? .jmhTurquoiseColor() : .whiteColor()
			
			let t = selected ? CGAffineTransformMakeRotation(CGFloat(M_PI)) : CGAffineTransformIdentity
			UIView.animateWithDuration(0.3) {
				self._downArrowImageView.transform = t
			}
		}
	}
	
	override var highlighted: Bool {
		didSet {
			contentView.backgroundColor = highlighted ? .whiteColor() : .clearColor()
			_filterNameLabel.textColor = highlighted ? .jmhTurquoiseColor() : .whiteColor()
			_filterSelectionLabel.textColor = highlighted ? .jmhTurquoiseColor() : .whiteColor()
			_downArrowImageView.tintColor = highlighted ? .jmhTurquoiseColor() : .whiteColor()
		}
	}
}
