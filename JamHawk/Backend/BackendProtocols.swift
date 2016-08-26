//
//  BackendProtocols.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

protocol APIRequestGeneration {
	func generateJSONData() -> NSData?
	func generateRequest() -> NSURLRequest?
}

protocol JamHawkJSONDecodable {
	init?(jsonData: NSData?)
}

extension JamHawkJSONDecodable where Self: JSONDecodable {
	init?(jsonData: NSData?) {
		guard let data = jsonData else { return nil }
		do {
			let json = try JSON(data: data)
			try self.init(json: json)
		} catch let error {
			let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
			print("Error: \(error), decoding JSON data in class: \(Self.self), data: \(dataString)")
			return nil
		}
	}
}

extension APIRequestGeneration where Self: JSONEncodable {
	func generateJSONData() -> NSData? {
		var data: NSData?
		do {
			data = try toJSON().serialize()
		} catch let error {
			print(error)
		}
		return data
	}
}