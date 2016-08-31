//
//  UserSession.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/11/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

private let kUserAccessTestToken = "apptesttoken"

class UserAccessSession {
	// MARK: - Properties: Private
	private let _session: NSURLSession
	
	// MARK: - Poperties: Public
	private var _signInDataTask: NSURLSessionDataTask?
	private var _signOutDataTask: NSURLSessionDataTask?
	private var _signUpDataTask: NSURLSessionDataTask?
	
	private var _userAccessDataTask: NSURLSessionDataTask?
	
	init(session: NSURLSession) {
		_session = session
	}
	
	func signUp(email email: String, password: String, callback: UserAccessCallback) {
		let creds = UserAccessCredentials(email: email, password: password)
		let input = UserAccessAPIInput(credentials: creds, action: .SignUp, token: kUserAccessTestToken, email: nil, password: nil)
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
		let input = UserAccessAPIInput(credentials: creds, action: .SignIn, token: kUserAccessTestToken, email: nil, password: nil)
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
		let input = UserAccessAPIInput(credentials: creds, action: .SignOut, token: nil, email: nil, password: nil)
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
	
	func changeEmail(toNewEmail email: String, usingCredentials credentials: (email: String, password: String), callback: UserAccessCallback) {
		let creds = UserAccessCredentials(email: credentials.email, password: credentials.password)
		let input = UserAccessAPIInput(credentials: creds, action: .ChangeEmail, token: nil, email: email, password: nil)
		guard let request = input.generateRequest() else { return }
		
		_userAccessDataTask?.cancel()
		_userAccessDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			
			let output = UserAccessAPIOutput(jsonData: data)
			dispatch_async(dispatch_get_main_queue()) {
				callback(error: error, output: output)
			}
		}
		_userAccessDataTask?.resume()
	}
	
	func changePassword(toNewPassword password: String, usingCredentials credentials: (email: String, password: String), callback: UserAccessCallback) {
		let creds = UserAccessCredentials(email: credentials.email, password: credentials.password)
		let input = UserAccessAPIInput(credentials: creds, action: .UpdatePass, token: nil, email: nil, password: password)
		guard let request = input.generateRequest() else { return }
		
		_userAccessDataTask?.cancel()
		_userAccessDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			
			let output = UserAccessAPIOutput(jsonData: data)
			dispatch_async(dispatch_get_main_queue()) {
				callback(error: error, output: output)
			}
		}
		_userAccessDataTask?.resume()
	}
	
	func sendResetPasswordEmail(toEmail email: String, callback: UserAccessCallback) {
		let input = UserAccessAPIInput(credentials: nil, action: .ResetPass, token: nil, email: email, password: nil)
		guard let request = input.generateRequest() else { return }
		
		_userAccessDataTask?.cancel()
		_userAccessDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			
			let output = UserAccessAPIOutput(jsonData: data)
			dispatch_async(dispatch_get_main_queue()) {
				callback(error: error, output: output)
			}
		}
		_userAccessDataTask?.resume()
	}
}