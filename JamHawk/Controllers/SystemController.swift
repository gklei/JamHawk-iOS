//
//  SystemControllers.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

class SystemController<Model> {
	func update(withModel model: Model) {
	}
}

public protocol Notifier {
	associatedtype Notification: RawRepresentable
}

public extension Notifier where Notification.RawValue == String, Self: AnyObject {
	
	// MARK: - Static Computed Variables
	private static func nameFor(notification: Notification) -> String {
		return "\(self).\(notification.rawValue)"
	}
	
	// MARK: - Instance Methods
	
	// Post
	func post(notification notification: Notification) {
		Self.postNotification(notification, object: self)
	}
	
	func post(notification notification: Notification, userInfo: [String: AnyObject]) {
		Self.postNotification(notification, object: self, userInfo: userInfo)
	}
	
	// MARK: - Static Functions
	
	// Post
	static func postNotification(notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
		let name = nameFor(notification)
		NSNotificationCenter.defaultCenter().postNotificationName(name, object: object, userInfo: userInfo)
	}
	
	// Add
	static func addObserver(observer: AnyObject, selector: Selector, notification: Notification) {
		let name = nameFor(notification)
		NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: name, object: nil)
	}
	
	// Remove
	static func removeObserver(observer: AnyObject, notification: Notification, object: AnyObject? = nil) {
		let name = nameFor(notification)
		NSNotificationCenter.defaultCenter().removeObserver(observer, name: name, object: object)
	}
}
