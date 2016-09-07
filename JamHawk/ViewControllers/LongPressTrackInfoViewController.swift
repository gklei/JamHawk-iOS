//
//  LongPressTrackInfoViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/22/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AsyncImageView
import MarqueeLabel

final class LongPressTrackInfoController: UIViewController, PlayerStoryboardInstantiable {
	
	// MARK: - Outlets
	@IBOutlet private var _mainImageView: AsyncImageView!
	@IBOutlet private var _songAndArtistNameLabel: MarqueeLabel!
	@IBOutlet private var _albumNameLabel: MarqueeLabel!
	@IBOutlet private var _albumArtWidthConstraint: NSLayoutConstraint!
	
	private let _thumbnailImageView = AsyncImageView()
	private let _thumbnailContainer = UIView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_mainImageView.crossfadeDuration = 0
		_mainImageView.layer.masksToBounds = true
		_mainImageView.layer.cornerRadius = 3.0
		
		_thumbnailImageView.crossfadeDuration = 0
		
		_thumbnailImageView.layer.cornerRadius = 3.0
		_thumbnailImageView.layer.borderColor = UIColor.whiteColor().CGColor
		_thumbnailImageView.layer.borderWidth = 2.0
		_thumbnailImageView.layer.masksToBounds = true
		
		_thumbnailContainer.layer.shadowColor = UIColor.jmhTurquoiseColor().CGColor
		_thumbnailContainer.layer.shadowOffset = CGSize.zero
		_thumbnailContainer.layer.shadowRadius = 10
		_thumbnailContainer.layer.shadowOpacity = 1
		
		_thumbnailContainer.addSubview(_thumbnailImageView)
		view.addSubview(_thumbnailContainer)
		
		_songAndArtistNameLabel.kerning = 1.2
		_albumNameLabel.kerning = 1.2
		
		switch UIDevice.currentDevice().deviceType {
		case .IPhone4, .IPhone4S:
			_albumArtWidthConstraint.constant = -40
		default: break
		}
	}
	
	func update(withViewModel viewModel: PlayerAPIOutputMetadataViewModel, thumbnailRect: CGRect) {
		_mainImageView.imageURL = viewModel.albumArtworkURL
		_thumbnailImageView.imageURL = viewModel.albumArtworkURL
		
		_thumbnailContainer.frame = thumbnailRect
		_thumbnailImageView.frame = _thumbnailContainer.bounds
		_thumbnailContainer.layer.shadowPath = UIBezierPath(rect: _thumbnailContainer.bounds).CGPath
		
		_albumNameLabel.text = viewModel.albumTitle
		_updateSongAndArtistLabel(withViewModel: viewModel)
	}
	
	private func _updateSongAndArtistLabel(withViewModel viewModel: PlayerAPIOutputMetadataViewModel) {
		
		guard let artistText = viewModel.artistName else { return }
		guard let songTitle = viewModel.songTitle else { return }
		
		let regularAttrs: [String : AnyObject] = [
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "OpenSans", size: 14)!
		]
		let boldAttrs: [String : AnyObject] = [
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "OpenSans-SemiBold", size: 14)!
		]
		
		let songAttributedString = NSAttributedString(string: songTitle, attributes: regularAttrs)
		let hyphenAttributedString = NSAttributedString(string: " – ", attributes: regularAttrs)
		let artistAttributedString = NSAttributedString(string: artistText, attributes: boldAttrs)
		
		let attributedString = NSMutableAttributedString()
		attributedString.appendAttributedString(artistAttributedString)
		attributedString.appendAttributedString(hyphenAttributedString)
		attributedString.appendAttributedString(songAttributedString)
		
		_songAndArtistNameLabel.attributedText = attributedString
		_songAndArtistNameLabel.restartLabel()
	}
}
