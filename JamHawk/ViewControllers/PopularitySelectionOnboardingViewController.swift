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
	
	private let _filterTypes: [OnboardingFilterType] = [.Mainstream, .Discovery, .Rising]
	
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
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let backSel = #selector(SignInViewController.backItemPressed)
		let continueSel = #selector(SignInViewController.continueItemPressed)
		
		updateLeftBarButtonItem(withTitle: "   Back", action: backSel)
		updateRightBarButtonItem(withTitle: "Continue   ", action: continueSel)
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
	
	private func _updatePopularitySelectedLabel() {
		var text = "Selected a Popularity"
		let count = filterViews.filter({$0.selected}).count
		if count > 0 {
			let popularityWord = count == 1 ? "Popularity" : "Popularities"
			text = "\(count) \(popularityWord) Selected"
		}
		_popularitySelectedLabel.text = text
	}
}

extension PopularitySelectionOnboardingViewController: OnboardingFilterViewDelegate {
	func filterViewSelected(view: OnboardingFilterView) {
		_updatePopularitySelectedLabel()
	}
	
	func filterViewDeselected(view: OnboardingFilterView) {
		_updatePopularitySelectedLabel()
	}
}
