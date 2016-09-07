//
//  PopularitySelectionOnboardingViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class PopularitySelectionOnboardingViewController: UIViewController {
	
	@IBOutlet private var container: UIView!
	
	@IBOutlet var filterViews: [OnboardingFilterView]!
	@IBOutlet private var _popularitySelectedLabel: UILabel!
	
	private let _filterTypes: [OnboardingFilterType] = [.Mainstream, .Discoveries, .Rising]
	
	var selectedFilterTypes: [OnboardingFilterType] {
		guard isViewLoaded() else { return [] }
		return filterViews.filter({$0.selected}).flatMap({$0.type})
	}
	
	// MARK: - Properties
	var backClosure: () -> Void = {}
	var continueClosure: () -> Void = {}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		backClosure = {
			self.navigationController?.popViewControllerAnimated(true)
		}
		
		for index in 0..<filterViews.count {
			let filterView = filterViews[index]
			filterView.delegate = self
			filterView.type = _filterTypes[index]
		}
		
		let size = adjustedFontSizeForCurrentDevice(28)
		_popularitySelectedLabel.font = UIFont(name: "OpenSans-Light", size: size)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let backSel = #selector(SignInViewController.backItemPressed)
		let continueSel = #selector(SignInViewController.continueItemPressed)
		
		updateLeftBarButtonItem(withTitle: "   Back", action: backSel)
		updateRightBarButtonItem(withTitle: "Continue   ", action: continueSel)
		_updateContinueItemEnabledState()
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	internal func continueItemPressed() {
		continueClosure()
	}
	
	internal func backItemPressed() {
		backClosure()
	}
	
	@IBAction private func _swipeLeftRecognized() {
		guard filterViews.filter({$0.selected}).count > 0 else { return }
		continueClosure()
	}
	
	@IBAction private func _swipeRightRecognized() {
		backClosure()
	}
	
	private func _updatePopularitySelectedLabel() {
		var text = "Select Popularity"
		let count = filterViews.filter({$0.selected}).count
		if count > 0 {
			let popularityWord = count == 1 ? "Popularity" : "Popularities"
			text = "\(count) \(popularityWord) Selected"
		}
		_popularitySelectedLabel.text = text
	}
	
	private func _updateContinueItemEnabledState() {
		let count = filterViews.filter({$0.selected}).count
		navigationItem.rightBarButtonItem?.enabled = count > 0
	}
}

extension PopularitySelectionOnboardingViewController: OnboardingFilterViewDelegate {
	func filterViewSelected(view: OnboardingFilterView) {
		_updatePopularitySelectedLabel()
		_updateContinueItemEnabledState()
	}
	
	func filterViewDeselected(view: OnboardingFilterView) {
		_updatePopularitySelectedLabel()
		_updateContinueItemEnabledState()
	}
}
