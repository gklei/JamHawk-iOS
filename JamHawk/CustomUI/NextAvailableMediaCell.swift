//
//  NextAvailableMediaCell.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/11/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AsyncImageView

class NextAvailableMediaCell: UICollectionViewCell {
	// MARK: - Outlet
	@IBOutlet private var _backgroundImageView: AsyncImageView!
	
	// MARK: - Overridden
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	// MARK: - Public
	func update(withMetatdata metatdata: PlayerAPIOutputMetadata) {
		guard let imageURL = NSURL(string: metatdata.imageURL ?? "") else { return }
		_backgroundImageView.imageURL = imageURL
	}
}
