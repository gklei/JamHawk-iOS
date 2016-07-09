//
//  UIViewController+BarButtonItems.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension UIViewController {
	public func removeLeftBarItem() {
		navigationItem.setLeftBarButtonItems([UIBarButtonItem.empty], animated: false)
	}
	
	public func removeRightBarItem() {
		navigationItem.setRightBarButtonItems([UIBarButtonItem.empty], animated: false)
	}
	
	public func usePlainArrowForBackButtonItem(withAction action: Selector? = nil) {
		let itemAction = action ?? #selector(UIViewController.ik_backButtonPressed)
		let item = UIBarButtonItem.back(target: self, action: itemAction)
		navigationItem.setLeftBarButtonItems([item], animated: false)
	}
	
	@objc private func ik_backButtonPressed() {
		navigationController?.popViewControllerAnimated(true)
	}
}