//
//  AppDelegate.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import AVFoundation
import Branch

public func updateNavigationBarItemColor(color: UIColor) {
	let appearance = UIBarButtonItem.appearance()
	
	let attrs: [String : AnyObject] = [
		NSForegroundColorAttributeName : color,
		NSFontAttributeName : UIFont(name: "OpenSans", size: 14)!,
		NSKernAttributeName : 0.7
	]
	appearance.setTitleTextAttributes(attrs, forState: .Normal)
}

public func adjustedFontSizeForCurrentDevice(proposedSize: CGFloat) -> CGFloat {
	switch UIDevice.currentDevice().deviceType {
	case .IPhone4, .IPhone4S, .IPhone5, .IPhone5C, .IPhone5S:
		return max((proposedSize - 2), 0)
	default: return proposedSize
	}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?
	var router: AppRouter?
	let session = JamHawkSession()
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		let branch = Branch.getInstance()
		branch.initSessionWithLaunchOptions(launchOptions) { (branchUniversalObject, branchLinkProperties, error) in
			guard branchLinkProperties != nil else { return }
			guard branchUniversalObject != nil else { return }
		}
		
		window = UIWindow()
		router = AppRouter(window: window!, session: session)
		
		return true
	}
	
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
		return Branch.getInstance().handleDeepLink(url)
	}
	
	func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
		return Branch.getInstance().continueUserActivity(userActivity)
	}
	
	private func _tryToUpdateStatusBar(color color: UIColor, withApplication application: UIApplication) {
		let statusBar = application.valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView
		statusBar?.backgroundColor = UIColor.blackColor()
	}
	
	
	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		
		do {
			try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
			try AVAudioSession.sharedInstance().setActive(true)
		} catch {
			print("Something went wrong with AVFoundation")
		}
		
		application.beginReceivingRemoteControlEvents()
	}
	
	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
}