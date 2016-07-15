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
	
	// MARK: - Properties
	static let reuseID = "ParentFilterCell"
	static let xibName = "ParentFilterCell"
	
	// MARK: - Overridden
	override func awakeFromNib() {
		super.awakeFromNib()
		backgroundColor = UIColor(white: 0, alpha: 0.5)
	}
	
	// MARK: - Public
	func update(withFilter filter: PlayerAPIOutputFilter) {
		_filterNameLabel.text = filter.label
		_filterSelectionLabel.text = "No Selection"
	}
}
