//
//  CoachingTipsState+Extensions.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

private extension CoachingTipsState {
	var mainTitleText: String {
		switch self {
		case .Welcome: return "Welcome to your\rJamhawk Dashboard"
		case .NextSong: return "Choose your\r next song"
		case .Filters: return "Your filters,\ryour way"
		}
	}
	
	var subtitleText: String {
		switch self {
		case .Welcome: return "This is where you can control the music player, select the next song, and update the filter selection."
		case .NextSong: return "Tap on one of the next avaialble tracks to queue it up, or long press to see additional information."
		case .Filters: return "Select multiple filters to get the best possible recommendations for the next track."
		}
	}
	
	var buttonTitleText: String {
		switch self {
		case .Welcome: return "First Tip"
		case .NextSong: return "Next Tip"
		case .Filters: return "I Got It"
		}
	}
	
	var iconImage: UIImage? {
		switch self {
		case .Welcome: return UIImage(named: "coaching_tips_jamhawk")
		case .NextSong: return UIImage(named: "coaching_tips_next_song")
		case .Filters: return UIImage(named: "coaching_tips_filters")
		}
	}
}
