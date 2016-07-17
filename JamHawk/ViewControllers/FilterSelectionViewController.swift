//
//  FilterSelectionViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/17/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class FilterSelectionViewController: UIViewController {
	
	// MARK: - Outlets
	// MARK: - Properties
	private let _filter: PlayerAPIOutputFilter
	
	// MARK: - Init
	required init?(coder aDecoder: NSCoder) {
		fatalError("initWithCoder: not implemented")
	}
	
	init(filter: PlayerAPIOutputFilter) {
		_filter = filter
		super.init(nibName: "FilterSelectionViewController", bundle: nil)
	}
	
	// MARK: - Overridden
	// MARK: - Setup
	// MARK: - Private
	// MARK: - Public
}
