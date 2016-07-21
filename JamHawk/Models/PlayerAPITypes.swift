//
//  PlayerAPITypealiases.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/7/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

typealias UserAccessCallback = (error: NSError?, output: UserAccessAPIOutput?) -> Void
typealias PlayerAPICallback = (error: NSError?, output: PlayerAPIOutput?) -> Void

typealias PlayerAPIMediaID = Int
typealias PlayerAPIFilterID = String
typealias PlayerAPIFilterCategory = String
typealias PlayerAPIFilterSelection = Dictionary<PlayerAPIFilterCategory, [PlayerAPIFilterID]>
typealias PlayerAPIMediaRatings = Dictionary<PlayerAPIMediaID, PlayerAPIOutputTrackRating>