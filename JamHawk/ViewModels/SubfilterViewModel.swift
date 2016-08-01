//
//  SubfilterViewModel.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/30/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

struct SubfilterViewModel: Equatable {
	let category: String
	let name: String
	let id: String
}

func ==(lhs: SubfilterViewModel, rhs: SubfilterViewModel) -> Bool {
	return lhs.category == rhs.category && lhs.id == rhs.id
}
