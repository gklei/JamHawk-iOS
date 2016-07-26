//
//  TrackRatingCell.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

private extension PlayerAPIOutputTrackRating {
	var imageName: String {
		switch self {
		case .Negative: return "downvote"
		case .Neutral: return ""
		case .Positive: return "upvote"
		}
	}
	
	var icon: UIImage? {
		return UIImage(named: imageName)
	}
}

class TrackRatingCell: UICollectionViewCell {
	static let reuseID = "TrackRatingCell"
	
	@IBOutlet private var _iconImageView: UIImageView!
	@IBOutlet private var _centerYConstraint: NSLayoutConstraint!
	
	func update(withRating rating: PlayerAPIOutputTrackRating) {
		_iconImageView.image = rating.icon
		
		// We need this weird hack for now to get the image to be centered on the Y-axis
		let offset = bounds.height * 0.02
		_centerYConstraint.constant = CGFloat(-rating.rawValue) * offset
	}
	
	override func drawRect(rect: CGRect) {
		UIColor.whiteColor().setFill()
		let context = UIGraphicsGetCurrentContext()
		
		UIColor.whiteColor().setStroke()
		CGContextSetLineWidth(context, 2)
		CGContextStrokeEllipseInRect(context, rect.insetBy(dx: 1, dy: 1))
	}
}
