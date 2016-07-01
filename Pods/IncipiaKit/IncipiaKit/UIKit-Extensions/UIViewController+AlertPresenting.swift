//
//  UIViewController+AlertPresenting.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

public extension UIViewController
{
	private var errorPresenter: ErrorPresenterViewController {
		for viewController in childViewControllers {
			if let presenter = viewController as? ErrorPresenterViewController {
				return presenter
			}
		}
		return _createAndAddErrorPresenter()
	}
	
	private func _createAndAddErrorPresenter() -> ErrorPresenterViewController
	{
		let errorPresenter = ErrorPresenterViewController()
		addChildViewController(errorPresenter)
		errorPresenter.didMoveToParentViewController(self)
		
		view.addSubview(errorPresenter.view)
		return errorPresenter
	}
	
	public func present(error: NSError, completion: (UIAlertAction -> Void)? = nil)
	{
		dispatch_async(dispatch_get_main_queue()) {
			self.errorPresenter.present(error, completion: completion)
		}
	}
	
	public func presentMessage(message: String, completion: (UIAlertAction -> Void)? = nil)
	{
		dispatch_async(dispatch_get_main_queue()) {
			self.errorPresenter.presentMessage(message, completion: completion)
		}
	}
}

private class ErrorPresenterViewController: UIViewController
{
	private var _isVisible = false
	private lazy var _okAction: UIAlertAction = {
		return UIAlertAction(title: "OK", style: .Default, handler: nil)
	}()
	
	private func _okAction(completion: (UIAlertAction -> Void)? = nil) -> UIAlertAction
	{
		return UIAlertAction(title: "OK", style: .Default, handler: completion)
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		view.alpha = 0
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewDidAppear(animated)
		_isVisible = true
	}
	
	override func viewWillDisappear(animated: Bool)
	{
		super.viewWillDisappear(animated)
		_isVisible = false
	}
}

private extension ErrorPresenterViewController
{
	override func present(error: NSError, completion: (UIAlertAction -> Void)? = nil)
	{
		guard _isVisible == true else { return }
		
		let alertController = UIAlertController(title: error.localizedDescription, message: error.localizedFailureReason, preferredStyle: .Alert)
		alertController.addAction(_okAction(completion))
		presentViewController(alertController, animated: true, completion: nil)
	}
	
	override func presentMessage(message: String, completion: (UIAlertAction -> Void)? = nil)
	{
		guard _isVisible == true else { return }
		
		let alertController = UIAlertController(title: message, message: nil, preferredStyle: .Alert)
		alertController.addAction(_okAction(completion))
		presentViewController(alertController, animated: true, completion: nil)
	}
}