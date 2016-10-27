//
//  WelcomeBackgroundViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension UINavigationController {
   public override func preferredStatusBarStyle() -> UIStatusBarStyle {
      if let rootViewController = self.viewControllers.last {
         return rootViewController.preferredStatusBarStyle()
      }
      return super.preferredStatusBarStyle()
   }
}

class WelcomeBackgroundViewController: UIViewController {
	
	let imageView = UIImageView()
   weak var presentingNavController: UINavigationController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .blackColor()
		
		imageView.image = UIImage(named: "welcome_background")
		imageView.alpha = 0.7
		imageView.contentMode = .ScaleAspectFill
		
		view.addAndFill(subview: imageView)
	}
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return presentingNavController?.preferredStatusBarStyle() ?? .LightContent
   }
}
