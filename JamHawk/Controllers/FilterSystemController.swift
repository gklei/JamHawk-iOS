//
//  FilterSystemController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

struct SubfilterViewModel {
	let category: String
	let name: String
	let id: String
}

final class FilterSystemController: SystemController<PlayerAPIOutputFilters> {
	private var _filters: PlayerAPIOutputFilters?
	
	var didUpdateModel: (controller: FilterSystemController) -> Void = {_ in}
	var didUpdateSelection: (controller: FilterSystemController) -> Void = {_ in}
	
	var selectedParentFilter: PlayerAPIOutputFilter?
	private var _subfilterDictionary: [PlayerAPIFilterCategory : [SubfilterViewModel]] = [:]
	
	override func update(withModel model: PlayerAPIOutputFilters?) {
		guard let model = model else { return }
		_filters = model
		
		_generateSubfilterViewModels()
		didUpdateModel(controller: self)
	}
	
	func selectSubfilter(atIndex index: Int) {
	}
	
	private func _generateSubfilterViewModels() {
		_subfilterDictionary = [:]
		
		_filters?.available?.forEach {
			var viewModels: [SubfilterViewModel] = []
			
			for index in 0..<$0.filterIDs.count {
				let name = $0.filterNames[index]
				let id = $0.filterIDs[index]
				let vm = SubfilterViewModel(category: $0.category, name: name, id: id)
				viewModels.append(vm)
			}
			_subfilterDictionary[$0.category] = viewModels
		}
	}
}

extension FilterSystemController: ParentFilterSelectionDataSource {
	var selectedParentFilterIndex: Int? {
		guard let available = _filters?.available else { return nil }
		guard let filter = selectedParentFilter else { return nil }
		return available.indexOf(filter)
	}
	
	var parentFilterViewModels: [PlayerAPIOutputFilterViewModel] {
		guard let parentFilters = _filters?.available else { return [] }
		return parentFilters.flatMap({ PlayerAPIOutputFilterViewModel(filter: $0) })
	}
	
	func selectFilter(atIndex index: Int) {
		guard let available = _filters?.available else { return }
		guard available.count > index else { return }
		
		let filter = available[index]
		selectedParentFilter = filter
		
		dispatch_async(dispatch_get_main_queue()) {
			self.didUpdateSelection(controller: self)
		}
	}
	
	func resetParentFilterSelection() {
		selectedParentFilter = nil
		
		dispatch_async(dispatch_get_main_queue()) {
			self.didUpdateSelection(controller: self)
		}
	}
}

extension FilterSystemController: SubfilterSelectionDataSource {
	var subfilterViewModels: [SubfilterViewModel] {
		guard let parent = selectedParentFilter else { return [] }
		return _subfilterDictionary[parent.category] ?? []
	}
}