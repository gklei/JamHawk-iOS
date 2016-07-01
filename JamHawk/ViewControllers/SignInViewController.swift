//
//  ViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import IncipiaKit

class SignInViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let bgImage = UIImage.convertGradientToImage([UIColor.blueColor(), UIColor.purpleColor()], frame: view.frame)
		
		let color = UIColor(patternImage: bgImage)
		view.backgroundColor = color
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
}

