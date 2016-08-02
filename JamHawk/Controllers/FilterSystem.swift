//
//  FilterSystem.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/25/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

final class FilterSystem: SystemController<PlayerAPIOutputFilters> {
	
	// MARK: - Properties
	private var _filters: PlayerAPIOutputFilters?
	
	internal(set) var selectedParentFilter: PlayerAPIOutputFilter?
	
	var selectedSubfilterIDs: [PlayerAPIFilterID] {
		return _selectedSubfilterViewModelsDictionary.values.flatMap({ $0.flatMap({ $0.id }) })
	}
	
	var filterSelection: PlayerAPIFilterSelection {
		var selection: PlayerAPIFilterSelection = [:]
		
		let categories = _filters?.available?.flatMap({ $0.category })
		categories?.forEach { category in
			selection[category] = []
		}
		
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
		postNotification(.didUpdateModel)
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

extension FilterSystem: ParentFilterSelectionDataSource {
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
		postNotification(.didUpdateParentFilterSelection)
	}
	
	func resetParentFilterSelection() {
		selectedParentFilter = nil
		postNotification(.didUpdateParentFilterSelection)
	}
}

extension FilterSystem: SubfilterSelectionDataSource {
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
		
		if _selectedSubfilterViewModelsDictionary[vm.category] != nil {
			_selectedSubfilterViewModelsDictionary[vm.category]?.append(vm)
		} else {
			_selectedSubfilterViewModelsDictionary[vm.category] = [vm]
		}
		
		postNotification(.didUpdateSubfilterSelection)
	}
	
	func deselectSubfilter(atIndex index: Int) {
		guard subfilterViewModels.count > index else { return }
		let vm = subfilterViewModels[index]
		
		if let index = _selectedSubfilterViewModelsDictionary[vm.category]?.indexOf(vm) {
			_selectedSubfilterViewModelsDictionary[vm.category]?.removeAtIndex(index)
		}
		
		postNotification(.didUpdateSubfilterSelection)
	}
}

extension FilterSystem: Notifier {
	enum Notification: String {
		case didUpdateModel
		case didUpdateParentFilterSelection
		case didUpdateSubfilterSelection
	}
}