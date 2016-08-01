//
//  PlayerControlsToolbar.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class PlayerControlsToolbar: UIToolbar {
	override func awakeFromNib() {
		super.awakeFromNib()
		
		translucent = false
		makeShadowTransparent()
		let color = UIColor(white: 0, alpha: 0.5)
		update(backgroundColor: color)
	}
}
