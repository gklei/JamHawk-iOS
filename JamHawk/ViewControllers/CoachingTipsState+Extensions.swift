//
//  CoachingTipsState+Extensions.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/26/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

extension CoachingTipsState {
	var mainTitleText: String {
		switch self {
		case .Welcome: return "Welcome to your\rJamhawk Dashboard"
		case .NextSong:
			switch UIDevice.currentDevice().deviceType {
			default: return "Choose your\rnext song"
			}
		case .Filters:
			switch UIDevice.currentDevice().deviceType {
			default: return "Your filters,\ryour way"
			}
		}
	}
	
	var subtitleText: String {
		switch self {
		case .Welcome: return "Simple and intuitive. Unearth the greatest music you never knew existed, by tapping your finger. No more sorting. No more scrolling. Let’s get started!"
		case .NextSong: return "Our custom recommendation system lets you pick the next song. Tap the icon for what you want. When the current song ends, the highlighted icon will begin playing."
		case .Filters: return "Want to change your recommendations? Use your filters to select genre, sub-genre and popularity. Tap once on each selection. Select as many as you want."
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
