//
//  Freddy+Extensions.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Freddy

typealias JSONDictionaryType = Dictionary<String, JSON>

extension JSON {
	
	private static func removeNullValues(inout dictionary: JSONDictionaryType) {
		let keysToRemove = dictionary.keys.filter { dictionary[$0]! == JSON.Null }
		for key in keysToRemove {
			dictionary.removeValueForKey(key)
		}
	}
	
	static func withNullValuesRemoved(dictionary: JSONDictionaryType) -> JSON {
		var copy = dictionary
		removeNullValues(&copy)
		return JSON(copy)
	}
}