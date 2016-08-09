//
//  VolumeSlider.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/4/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class VolumeSlider: UISlider {
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		minimumTrackTintColor = UIColor.jmhTurquoiseColor()
		maximumTrackTintColor = UIColor.jmhLightGrayColor()
		
		let thumbImage = UIImage(named: "volume_slider_thumb_image")
		setThumbImage(thumbImage, forState: .Normal)
	}
	
	override func trackRectForBounds(bounds: CGRect) -> CGRect {
		let boundsThickness: CGFloat = bounds.height
		let trackThickness: CGFloat = 4
		
		let inset = (boundsThickness - trackThickness) * 0.5
		return bounds.insetBy(dx: 0, dy: inset)
	}
}
