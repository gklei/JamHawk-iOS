//
//  WelcomeBackgroundViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class WelcomeBackgroundViewController: UIViewController {
	
	let imageView = UIImageView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .blackColor()
		
		imageView.image = UIImage(named: "welcome_background")
		imageView.alpha = 0.5
		imageView.contentMode = .ScaleAspectFill
		
		view.addAndFill(subview: imageView)
	}
}
