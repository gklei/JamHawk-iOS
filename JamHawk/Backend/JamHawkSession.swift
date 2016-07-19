//
//  BackendCommunicator.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

class JamHawkSession: PlayerAPIService {
	
	// MARK: - Properties
	private let _userSession: UserAccessSession
	private let _playerSession: PlayerSession
	
	init() {
		let config = NSURLSessionConfiguration.defaultSessionConfiguration()
		config.HTTPCookieAcceptPolicy = .Always
		config.HTTPCookieStorage = .sharedHTTPCookieStorage()
		
		let session = NSURLSession(configuration: config)
		
		_userSession = UserAccessSession(session: session)
		_playerSession = PlayerSession(session: session)
	}
	
	// MARK: - Public: User Access
	func signUp(email email: String, password: String, callback: UserAccessCallback) {
		_userSession.signUp(email: email, password: password, callback: callback)
	}
	
	func signIn(email email: String, password: String, callback: UserAccessCallback) {
		_userSession.signIn(email: email, password: password, callback: callback)
	}
	
	func signOut(email email: String, password: String, callback: UserAccessCallback) {
		_userSession.signOut(email: email, password: password, callback: callback)
	}
	
	// MARK: - Testing
	func signInWithTestCreds(callback: UserAccessCallback) {
		_userSession.signInWithTestCreds(callback)
	}
	
	func signOutWithTestCreds(callback: UserAccessCallback) {
		_userSession.signOutWithTestCreds(callback)
	}
	
	// MARK: - Public: Player
	func instantiatePlayer(callback: PlayerAPICallback) {
		_playerSession.instantiatePlayer(callback)
	}
	
	func requestNextTrack(callback: PlayerAPICallback) {
		_playerSession.requestNextTrack(callback)
	}
}