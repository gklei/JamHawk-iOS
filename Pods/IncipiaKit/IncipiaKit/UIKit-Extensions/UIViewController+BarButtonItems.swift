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
	
	public func updateLeftBarButtonItem(withImageName name: String, action: Selector) {
		let item = UIBarButtonItem(image: UIImage(named: name), style: .Plain, target: self, action: action)
		navigationItem.setLeftBarButtonItems([item], animated: false)
	}
	
	public func updateRightBarButtonItem(withImageName name: String, action: Selector) {
		let item = UIBarButtonItem(image: UIImage(named: name), style: .Plain, target: self, action: action)
		navigationItem.setRightBarButtonItems([item], animated: false)
	}
	
	public func updateLeftBarButtonItem(withTitle title: String, action: Selector) {
		let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: action)
		navigationItem.setLeftBarButtonItems([item], animated: false)
	}
	
	public func updateRightBarButtonItem(withTitle title: String, action: Selector) {
		let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: action)
		navigationItem.setRightBarButtonItems([item], animated: false)
	}
	
	@objc private func ik_backButtonPressed() {
		navigationController?.popViewControllerAnimated(true)
	}
}