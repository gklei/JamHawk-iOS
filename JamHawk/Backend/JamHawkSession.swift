//
//  BackendCommunicator.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

protocol PlayerAPIService {
	func instantiatePlayer(callback: PlayerAPICallback)
	func sendRequest(needNext needNext: Bool, needMedia: Bool, needFilters: Bool, updates: PlayerAPIInputUpdates, events: [PlayerAPIInputEvent]?,  callback: PlayerAPICallback)
}

class JamHawkSession: PlayerAPIService {
	
	// MARK: - Properties
	private let _userSession: UserAccessSession
	private let _playerSession: PlayerSession
	internal(set) var requestID: Int = 0
	
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
		requestID = requestID + 1
	}
	
	func sendRequest(needNext needNext: Bool, needMedia: Bool, needFilters: Bool, updates: PlayerAPIInputUpdates, events: [PlayerAPIInputEvent]? = nil, callback: PlayerAPICallback) {
		_playerSession.sendRequest(needNext: needNext, needMedia: needMedia, needFilters: needFilters, updates: updates, events: events, requestID: requestID, callback: callback)
		requestID = requestID + 1
	}
}