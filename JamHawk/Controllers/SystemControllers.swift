//
//  SystemControllers.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/24/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

protocol SystemUpdatingClosureSettable {
	associatedtype ControllerType
	
	var didUpdateModel: (controller: Self) -> Void { get set }
	var didUpdateSelection: (controller: Self) -> Void { get set }
}

class SystemController<Model>{
	func update(withModel model: Model) {
	}
}

// Do we need this guy?
class RequestController {
}
