//
//  UserSession.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/11/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

private let kUserAccessTestToken = "apptesttoken"
private let kTestEmail = "hello@incipia.co"
private let kTestPassword = "helloo"

class UserAccessSession {
	// MARK: - Properties: Private
	private let _session: NSURLSession
	
	// MARK: - Poperties: Public
	private var _signInDataTask: NSURLSessionDataTask?
	private var _signOutDataTask: NSURLSessionDataTask?
	private var _signUpDataTask: NSURLSessionDataTask?
	
	init(session: NSURLSession) {
		_session = session
	}
	
	func signUp(email email: String, password: String, callback: UserAccessCallback) {
		
		let creds = UserAccessCredentials(email: email, password: password)
		let input = UserAccessAPIInput(credentials: creds, action: .SignUp, token: kUserAccessTestToken)
		guard let request = input.generateRequest() else { return }
		
		_signUpDataTask?.cancel()
		_signUpDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			
			let output = UserAccessAPIOutput(jsonData: data)
			dispatch_async(dispatch_get_main_queue()) {
				callback(error: error, output: output)
			}
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
			dispatch_async(dispatch_get_main_queue()) {
				callback(error: error, output: output)
			}
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
			dispatch_async(dispatch_get_main_queue()) {
				callback(error: error, output: output)
			}
		}
		_signOutDataTask?.resume()
	}
	
	func signInWithTestCreds(callback: UserAccessCallback) {
		signIn(email: kTestEmail, password: kTestPassword, callback: callback)
	}
	
	func signOutWithTestCreds(callback: UserAccessCallback) {
		signOut(email: kTestEmail, password: kTestPassword, callback: callback)
	}
}