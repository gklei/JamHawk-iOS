//
//  BackendCommunicator.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

private let kUserAccessTestToken = "apptesttoken"
private let kTestEmail = "gregory@incipia.co"
private let kTestPassword = "hello"

typealias SignInCallback = (success: Bool, message: String?) -> Void
typealias SignUpCallback = (success: Bool, message: String?) -> Void

class JamHawkSession
{
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
	
	// MARK: - Public
	func signIn(email email: String, password: String, callback: SignInCallback? = nil) {
		
		let request = NSMutableURLRequest(URL: JamHawkAPIURLProvider.user)
		request.HTTPMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		let input = UserAccessAPIInput(email: email, password: password, action: UserInputAction.SignIn, token: kUserAccessTestToken)
		
		do {
			let inputData = try input.toJSON().serialize()
			guard let inputString = NSString(data: inputData, encoding: NSUTF8StringEncoding) else { fatalError() }
			let body = "clazha_access=\(inputString)".dataUsingEncoding(NSUTF8StringEncoding)
			request.HTTPBody = body
			
			_session.dataTaskWithRequest(request) { (data, response, error) in
				if let error = error {
					print(error)
				}
				if let data = data {
					let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
					print(contents)
				}
				if let response = response {
					print(response)
				}
			}.resume()
			
		} catch let error {
			fatalError("\(error)")
		}
	}
	
	func signUp(email email: String, password: String, callback: SignUpCallback? = nil) {
	}
	
	// MARK: - Testing
	func signInWithTestCreds() {
		
		let request = NSMutableURLRequest(URL: JamHawkAPIURLProvider.user)
		request.HTTPMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		let input = UserAccessAPIInput(email: kTestEmail, password: kTestPassword, action: UserInputAction.SignIn, token: kUserAccessTestToken)
		
		do {
			let inputData = try input.toJSON().serialize()
			guard let inputString = NSString(data: inputData, encoding: NSUTF8StringEncoding) else { fatalError() }
			let body = "clazha_access=\(inputString)".dataUsingEncoding(NSUTF8StringEncoding)
			request.HTTPBody = body
			
			_signInDataTask?.cancel()
			_signInDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
				if let error = error {
					print(error)
				}
				if let data = data {
					let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
					print(contents)
				}
				if let response = response {
					print(response)
				}
			}
			
			_signInDataTask?.resume()
			
		} catch let error {
			fatalError("\(error)")
		}
	}
	
	func signOutWithTestCreds() {
		
		let request = NSMutableURLRequest(URL: JamHawkAPIURLProvider.user)
		request.HTTPMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		let input = UserAccessAPIInput(email: kTestEmail, password: kTestPassword, action: UserInputAction.SignOut, token: kUserAccessTestToken)
		
		do {
			let inputData = try input.toJSON().serialize()
			guard let inputString = NSString(data: inputData, encoding: NSUTF8StringEncoding) else { fatalError() }
			let body = "clazha_access=\(inputString)".dataUsingEncoding(NSUTF8StringEncoding)
			request.HTTPBody = body
			
			_signOutDataTask?.cancel()
			_signOutDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
				if let error = error {
					print(error)
				}
				if let data = data {
					let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
					print(contents)
				}
			}
			_signOutDataTask?.resume()
			
		} catch let error {
			fatalError("\(error)")
		}
	}
	
	func instantiateTestPlayer() {
		let playerRequest = NSMutableURLRequest(URL: JamHawkAPIURLProvider.player)
		
		let statusDict: [String: AnyObject] = ["playerID" : "", "requestID": 0, "needInstance": true, "needMedia":true, "needNext": false, "needFilters": false]
		let instanceDict: [String: AnyObject] = ["token" : "apptesttoken", "needPlayerID" : true, "needOptions" : true]
		let playerParams = ["status" : statusDict, "instance" : instanceDict]
		
		do {
			let playerParamsData = try NSJSONSerialization.dataWithJSONObject(playerParams, options: [])
			guard let playerParamsString = NSString(data: playerParamsData, encoding: NSUTF8StringEncoding) else { fatalError() }

			playerRequest.HTTPBody = "clazha_player=\(playerParamsString)".dataUsingEncoding(NSUTF8StringEncoding)
			
			_playerDataTask?.cancel()
			_playerDataTask = _session.dataTaskWithRequest(playerRequest) { (data, response, error) in
				if let error = error {
					print(error)
				}
				
				if let data = data {
					let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
					print(contents)
				}
				
				if let response = response {
					print(response)
				}
			}
			_playerDataTask?.resume()
			
		} catch let error {
			print(error)
		}
	}
}