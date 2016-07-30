//
//  FilterSystemController.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

final class FilterSystemController: SystemController<PlayerAPIOutputFilters> {
	private var _filters: PlayerAPIOutputFilters?
	
	// MARK: - Closurees
	var didUpdateModel: (controller: FilterSystemController) -> Void = {_ in}
	var didUpdateParentFilterSelection: (controller: FilterSystemController) -> Void = {_ in}
	var didUpdateSubfilterFilterSelection: (controller: FilterSystemController) -> Void = {_ in}
	
	internal(set) var selectedParentFilter: PlayerAPIOutputFilter?
	
	var selectedSubfilterIDs: [PlayerAPIFilterID] {
		return _selectedSubfilterViewModelsDictionary.values.flatMap({ $0.flatMap({ $0.id }) })
	}
	
	var filterSelection: PlayerAPIFilterSelection {
		var selection: PlayerAPIFilterSelection = [:]
		for (category, vms) in _selectedSubfilterViewModelsDictionary {
			selection[category] = vms.flatMap({ $0.id })
		}
		return selection
	}
	
	// MARK: - Caching
	private var _subfilterViewModelsDictionary: [PlayerAPIFilterCategory : [SubfilterViewModel]] = [:]
	private var _selectedSubfilterViewModelsDictionary: [PlayerAPIFilterCategory : [SubfilterViewModel]] = [:]
	
	override func update(withModel model: PlayerAPIOutputFilters?) {
		guard let model = model else { return }
		_filters = model
		
		_generateSubfilterViewModels()
		didUpdateModel(controller: self)
	}
	
	private func _generateSubfilterViewModels() {
		_subfilterViewModelsDictionary = [:]
		
		_filters?.available?.forEach {
			var viewModels: [SubfilterViewModel] = []
			
			for index in 0..<$0.filterIDs.count {
				let name = $0.filterNames[index]
				let id = $0.filterIDs[index]
				let vm = SubfilterViewModel(category: $0.category, name: name, id: id)
				viewModels.append(vm)
			}
			_subfilterViewModelsDictionary[$0.category] = viewModels
		}
	}
}

extension FilterSystemController: ParentFilterSelectionDataSource {
	var selectedParentFilterIndex: Int? {
		guard let available = _filters?.available else { return nil }
		guard let filter = selectedParentFilter else { return nil }
		return available.indexOf(filter)
	}
	
	var selectedSubfilterViewModels: [SubfilterViewModel] {
		guard let parent = selectedParentFilter else { return [] }
		return _selectedSubfilterViewModelsDictionary[parent.category] ?? []
	}

	var parentFilterViewModels: [PlayerAPIOutputFilterViewModel] {
		guard let parentFilters = _filters?.available else { return [] }
		let selectedIDs = _filters?.selected ?? []
		return parentFilters.flatMap({ PlayerAPIOutputFilterViewModel(filter: $0, selectedSubfilterIDs: selectedIDs) })
	}
	
	func selectFilter(atIndex index: Int) {
		guard let available = _filters?.available else { return }
		guard available.count > index else { return }
		
		let filter = available[index]
		selectedParentFilter = filter
		
		dispatch_async(dispatch_get_main_queue()) {
			self.didUpdateParentFilterSelection(controller: self)
		}
	}
	
	func resetParentFilterSelection() {
		selectedParentFilter = nil
		didUpdateParentFilterSelection(controller: self)
	}
}

extension FilterSystemController: SubfilterSelectionDataSource {
	var subfilterViewModels: [SubfilterViewModel] {
		guard let parent = selectedParentFilter else { return [] }
		return _subfilterViewModelsDictionary[parent.category] ?? []
	}
	
	var selectedSubfilterIndicies: [Int] {
		return selectedSubfilterViewModels.flatMap({ subfilterViewModels.indexOf($0) })
	}
	
	func selectSubfilter(atIndex index: Int) {
		guard subfilterViewModels.count > index else { return }
		let vm = subfilterViewModels[index]
		
		if var selected = _selectedSubfilterViewModelsDictionary[vm.category] {
			selected.append(vm)
			_selectedSubfilterViewModelsDictionary[vm.category] = selected
		} else {
			_selectedSubfilterViewModelsDictionary[vm.category] = [vm]
		}
		didUpdateSubfilterFilterSelection(controller: self)
	}
	
	func deselectSubfilter(atIndex index: Int) {
		guard subfilterViewModels.count > index else { return }
		let vm = subfilterViewModels[index]
		
		if let index = _selectedSubfilterViewModelsDictionary[vm.category]?.indexOf(vm) {
			_selectedSubfilterViewModelsDictionary[vm.category]?.removeAtIndex(index)
		}
		didUpdateSubfilterFilterSelection(controller: self)
	}
}