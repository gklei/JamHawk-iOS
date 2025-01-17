//
//  GenreSelectionOnboardingViewController.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class GenreSelectionOnboardingViewController: UIViewController {
	
	@IBOutlet private var container: UIView!
	@IBOutlet var filterViews: [OnboardingFilterView]!
	@IBOutlet private var _genresSelectedLabel: UILabel!

	private let _filterTypes: [OnboardingFilterType] = [.Blues, .HipHop, .AlternativeRock, .Pop, .RnB]
	
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
		_genresSelectedLabel.font = UIFont(name: "OpenSans-Light", size: size)
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
	
	private func _updateGenresSelectedLabel() {
		var text = "Select a Genre"
		let count = filterViews.filter({$0.selected}).count
		if count > 0 {
			let genreWord = count == 1 ? "Genre" : "Genres"
			text = "\(count) \(genreWord) Selected"
		}
		_genresSelectedLabel.text = text
	}
	
	private func _updateContinueItemEnabledState() {
		let count = filterViews.filter({$0.selected}).count
		navigationItem.rightBarButtonItem?.enabled = count > 0
	}
}

extension GenreSelectionOnboardingViewController: OnboardingFilterViewDelegate {
	func filterViewSelected(view: OnboardingFilterView) {
		_updateGenresSelectedLabel()
		_updateContinueItemEnabledState()
	}
	
	func filterViewDeselected(view: OnboardingFilterView) {
		_updateGenresSelectedLabel()
		_updateContinueItemEnabledState()
	}
}
