//
//  BackendCommunicator.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import Freddy

private let kUserAccessTestToken = "apptesttoken"
private let kTestEmail = "hello@incipia.co"
private let kTestPassword = "helloo"

typealias UserAccessCallback = (error: NSError?, output: UserAccessAPIOutput?) -> Void
typealias PlayerInstantiationCallback = (error: NSError?, output: PlayerAPIOutput?) -> Void

class JamHawkSession {
	// MARK: - Properties
	private lazy var _session: NSURLSession = {
		let config = NSURLSessionConfiguration.defaultSessionConfiguration()
		config.HTTPCookieAcceptPolicy = .Always
		config.HTTPCookieStorage = .sharedHTTPCookieStorage()
		
		let session = NSURLSession(configuration: config)
		return session
	}()
	
	private var _signInDataTask: NSURLSessionDataTask?
	private var _signOutDataTask: NSURLSessionDataTask?
	private var _signUpDataTask: NSURLSessionDataTask?
	private var _playerDataTask: NSURLSessionDataTask?
	
	// MARK: - Public: User Access
	func signUp(email email: String, password: String, callback: UserAccessCallback) {
		let creds = UserAccessCredentials(email: email, password: password)
		let input = UserAccessAPIInput(credentials: creds, action: .SignUp, token: kUserAccessTestToken)
		guard let request = input.generateRequest() else { return }
		
		_signUpDataTask?.cancel()
		_signUpDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			
			let output = UserAccessAPIOutput(jsonData: data)
			callback(error: error, output: output)
		}
		_signUpDataTask?.resume()
	}
	
	func signIn(email email: String, password: String, callback: UserAccessCallback) {
		let creds = UserAccessCredentials(email: email, password: password)
		let input = UserAccessAPIInput(credentials: creds, action: .SignIn, token: kUserAccessTestToken)
		guard let request = input.generateRequest() else { return }
		
		_signInDataTask?.cancel()
		_signInDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			
			let output = UserAccessAPIOutput(jsonData: data)
			callback(error: error, output: output)
		}
		_signInDataTask?.resume()
	}
	
	func signOut(email email: String, password: String, callback: UserAccessCallback) {
		let creds = UserAccessCredentials(email: email, password: password)
		let input = UserAccessAPIInput(credentials: creds, action: .SignOut, token: kUserAccessTestToken)
		guard let request = input.generateRequest() else { return }
		
		_signOutDataTask?.cancel()
		_signOutDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			
			let output = UserAccessAPIOutput(jsonData: data)
			callback(error: error, output: output)
		}
		_signOutDataTask?.resume()
	}
	
	// MARK: - Public: Player
	func instantiatePlayer(callback: PlayerInstantiationCallback) {
		let instanceInput = PlayerAPIInputInstance(token: nil, needPlayerID: true, needOptions: true, isMobile: true, preloadSync: nil)
		let statusInput = PlayerAPIInputStatus.instanceRequestStatus()
		let input = PlayerAPIInput(instance: instanceInput, status: statusInput, updates: nil, events: nil)
		guard let request = input.generateRequest() else { return }
		
		_playerDataTask?.cancel()
		_playerDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			
			let output = PlayerAPIOutput(jsonData: data)
			callback(error: error, output: output)
		}
		_playerDataTask?.resume()
	}
	
	// MARK: - Testing
	func signInWithTestCreds(callback: UserAccessCallback) {
		signIn(email: kTestEmail, password: kTestPassword, callback: callback)
	}
	
	func signOutWithTestCreds(callback: UserAccessCallback) {
		signOut(email: kTestEmail, password: kTestPassword, callback: callback)
	}
}