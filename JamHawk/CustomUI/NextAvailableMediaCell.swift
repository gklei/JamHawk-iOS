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
	// MARK: - Properties
	static let reuseID = "NextAvailableMediaCell"
	static let xibName = "NextAvailableMediaCell"
	
	// MARK: - Outlet
	@IBOutlet private var _backgroundImageView: AsyncImageView!
	
	// MARK: - Overridden
	override func awakeFromNib() {
		super.awakeFromNib()
		layer.cornerRadius = 3.0
	}
	
	// MARK: - Public
	func update(withViewModel vm: PlayerAPIOutputMetadataViewModel) {
		_backgroundImageView.imageURL = vm.albumArtworkURL
	}
	
	func reset() {
		AsyncImageLoader.sharedLoader().cancelLoadingImagesForTarget(_backgroundImageView)
	}
}
