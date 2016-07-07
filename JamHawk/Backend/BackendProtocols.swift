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