//
//  JamHawkAPI.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/5/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

private let kUserAPIURLString = "https://feat3.clashauddevelop.com/clazha/access/api/user"
private let kPlayerAPIURLString = "https://feat3.clashauddevelop.com/clazha/player/media-list"

class JamHawkAPIURLProvider
{
	static var user: NSURL {
		guard let url = NSURL(string: kUserAPIURLString) else { fatalError("Couldn't generate user API URL") }
		return url
	}
	
	static var player: NSURL {
		guard let url = NSURL(string: kPlayerAPIURLString) else { fatalError("Couldn't generate player API URL") }
		return url
	}
}
